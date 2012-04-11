Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab2DKThz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:37:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52349 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2DKThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:37:53 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [3.4-rc1][Regression][network wireless] 'task xxxx blocked for more than 120 seconds' after resume
Date: Wed, 11 Apr 2012 21:37:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc2; KDE/4.7.4; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <201204022157.05598.maciej.rutecki@gmail.com> <1333657409.3494.22.camel@jlt3.sipsolutions.net> <20120405210122.GA12135@electric-eye.fr.zoreil.com>
In-Reply-To: <20120405210122.GA12135@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204112137.47854.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 5 kwietnia 2012 o 23:01:22 Francois Romieu wrote:
> Johannes Berg <johannes@sipsolutions.net> :
> > On Thu, 2012-04-05 at 22:08 +0200, Maciej Rutecki wrote:
> > > Dmesg when CONFIG_LOCKDEP is set:
> > > 
> > > http://mrutecki.pl/download/kernel/3.4-rc1/netdev_resume/dmesg-lockdep.
> > > txt
> > 
> > Looks like rtl8169's fault:
> Fix is on the way to mainline, see http://patchwork.ozlabs.org/patch/150541
Seems be resolved in -rc2. Only in dmesg still I have messages "netlink: 140 
bytes leftover after parsing attributes.". It seems be another issue.

Thanks
-- 
Maciej Rutecki
http://www.mrutecki.pl
