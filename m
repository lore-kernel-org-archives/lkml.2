Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab1FXOzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:55:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1FXOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:55:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Date: Fri, 24 Jun 2011 16:55:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
References: <20110618172537.GH3441@infomag.iguana.be> <20110622201346.GE26745@infomag.iguana.be> <4E034A09.6050107@teksavvy.com>
In-Reply-To: <4E034A09.6050107@teksavvy.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241655.03637.arnd@arndb.de>
X-Provags-ID: V02:K0:FEAdPpqw3lqZw1jT9Uuvoojn/FuFG3vFu8YtPDxsN4S
 gt6kf2sBZ4wpII1llwwxJQANiG3HH9vzkyIWcPHIvsr1GXuQKP
 3Lt+xh8m+2Sex/DBHhOfrHi24+xgC4Z5dUQDxoMrRFUuInWPPc
 z/4MmEZNBKnCGyg3CpSLNxIJCmDACKWQPluvLKtweivWM0jAbM
 epuGYwBXvOoLwX9oV8+Cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 16:13:29 Mark Lord wrote:
> On 11-06-22 04:13 PM, Wim Van Sebroeck wrote:
> > 
> > This is another tricky thing were developers will always discuss about.
> > What you don't want to happen is that the watchdog reboots your system when it does
> > an fsck at bootup (for instance because the system rebooted by the watchdog and left
> > the filesystem in a dirty state...).
> > 
> > So it's more complex if you look at the overal system...
> 
> Sure, but that's got little to do with wanting a kernel parameter to OPTIONALLY
> enable a hardware watchdog timer at boot.
> 
> Filesystem checks are a separate issue, easily worked around in practice.

I agree, it's nice to give system integrators the option to enable the watchdog
very early, the problems that Wim mentioned need to be solved in user space
but are not a serious limitation.

	Arnd
