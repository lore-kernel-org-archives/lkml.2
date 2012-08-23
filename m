Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2HWOfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:35:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36388 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2HWOfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <50363B12.4060009@archlinux.org>
References: <50363B12.4060009@archlinux.org>
Date: Thu, 23 Aug 2012 22:35:08 +0800
Message-ID: <CA++bM2tMVLQLn2=_MwhEp79xJpj6fjz+Smd5ZpE5dLKObe+hCw@mail.gmail.com>
Subject: Re: Serious regression in 3.5's iTCO_wdt, does anyone care?
From: Feng Tang <feng.79.tang@gmail.com>
To: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Peter Tyser <ptyser@xes-inc.com>,
        Wim Van Sebroeck <wim@iguana.be>, Aaron Sierra <asierra@xes-inc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Tobias Powalowski <tpowa@archlinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/23 Thomas Bächler <thomas@archlinux.org>:
> This regards the following commit in the Linus tree:
>
> commit 887c8ec7219fc8eba78bb8f44a74c660934e9b98
> Author: Aaron Sierra <asierra@xes-inc.com>
> Date:   Fri Apr 20 14:14:11 2012 -0500
>
>     watchdog: Convert iTCO_wdt driver to mfd model
>
> Ever since the Linux 3.5 update, the iTCO_wdt driver has been completely
> non-functional on every machine I encountered due to the above
> conversion. A bug report for this problem has been open at
> https://bugzilla.kernel.org/show_bug.cgi?id=44991 for over a month.
>
> Yet, neither the author of the commit, nor the people who signed off on
> it have reacted to the bug report.
>
> At this point, I believe that none of you are actually aware of the
> problem and I write you to change that unfortunate situation.

There is already a patch posted for this bug, pls check
https://lkml.org/lkml/2012/8/14/309
and the discussion

Thanks,
Feng
