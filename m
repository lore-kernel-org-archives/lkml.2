Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2G1NHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 09:07:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2G1NHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 09:07:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] sh: pfc: Fix build issues in pinctrl.c
Date: Sat, 28 Jul 2012 15:13:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201207280007.04480.rjw@sisk.pl> <20120728002911.GG30468@linux-sh.org>
In-Reply-To: <20120728002911.GG30468@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207281513.04621.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 28, 2012, Paul Mundt wrote:
> On Sat, Jul 28, 2012 at 12:07:04AM +0200, Rafael J. Wysocki wrote:
> > 
> > First off, drivers/sh/pfc/pinctrl.c doesn't build after commit
> > 5d589b0 (pinctrl: remove pinctrl_remove_gpio_range), because
> > sh_pfc_pinctrl_remove() uses the function that has been removed by
> > that commit.  Fix this by removing the pinctrl_remove_gpio_range()
> > call, which is not necessary any more, from sh_pfc_pinctrl_remove().
> > 
> > Second, the compiler complains correctly that there's an unused
> > local variable in sh_pfc_pinconf_set().  Fix this by removing the
> > definition of that variable.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Already fixed in my tree, as pointed out when Iwamatsu-san sent the same
> patch. 

I must have overlooked that one.  Thanks!
