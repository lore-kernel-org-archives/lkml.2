Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2G1A3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 20:29:22 -0400
Received: from linux-sh.org ([111.68.239.195]:37301 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2G1A3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:29:21 -0400
Date: Sat, 28 Jul 2012 09:29:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] sh: pfc: Fix build issues in pinctrl.c
Message-ID: <20120728002911.GG30468@linux-sh.org>
References: <201207280007.04480.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207280007.04480.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 12:07:04AM +0200, Rafael J. Wysocki wrote:
> 
> First off, drivers/sh/pfc/pinctrl.c doesn't build after commit
> 5d589b0 (pinctrl: remove pinctrl_remove_gpio_range), because
> sh_pfc_pinctrl_remove() uses the function that has been removed by
> that commit.  Fix this by removing the pinctrl_remove_gpio_range()
> call, which is not necessary any more, from sh_pfc_pinctrl_remove().
> 
> Second, the compiler complains correctly that there's an unused
> local variable in sh_pfc_pinconf_set().  Fix this by removing the
> definition of that variable.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Already fixed in my tree, as pointed out when Iwamatsu-san sent the same
patch. 
