Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0HBVCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:02:47 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43846 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0HBVCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:02:46 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Backlund <tmb@mandriva.org>, Michal Marek <mmarek@suse.cz>,
        linuxppc-dev@ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bug-make@gnu.org
Subject: Re: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
	<4C5686FF.9010803@mandriva.org>
	<20100802182848.GA16394@merkur.ravnborg.org>
	<4C572EB0.7060706@mandriva.org>
	<20100802205121.GA16520@merkur.ravnborg.org>
X-Yow: Are we on STRIKE yet?
Date: Mon, 02 Aug 2010 23:02:43 +0200
In-Reply-To: <20100802205121.GA16520@merkur.ravnborg.org> (Sam Ravnborg's
	message of "Mon, 2 Aug 2010 22:51:21 +0200")
Message-ID: <m2zkx4ohho.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> +bootwrapper_install

Missing colon.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
