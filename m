Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1CKUbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:31:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1CKUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:31:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: Remove the pm_message_t argument from driver suspend
Date: Fri, 11 Mar 2011 21:31:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: cpufreq@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
References: <201103102113.05946.rjw@sisk.pl> <20110310205008.GB7750@redhat.com>
In-Reply-To: <20110310205008.GB7750@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112131.47862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 10, 2011, Dave Jones wrote:
> On Thu, Mar 10, 2011 at 09:13:05PM +0100, Rafael J. Wysocki wrote:
>  > From: Rafael J. Wysocki <rjw@sisk.pl>
>  > 
>  > None of the existing cpufreq drivers uses the second argument of
>  > its .suspend() callback (which isn't useful anyway), so remove it.
>  > 
>  > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>  > ---
>  > 
>  > Hi,
>  > 
>  > This patch is requisite for sysdevs rework discussed here:
>  > https://lkml.org/lkml/2011/3/9/439
>  > Please apply or let me know if I can take it to the suspend tree.
> 
> Looks ok to me.
> 
> applied and queued for .39

Thanks!

Rafael

