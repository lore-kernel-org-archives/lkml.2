Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1G3GPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:15:05 -0400
Received: from mout0.freenet.de ([195.4.92.90]:51858 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1G3GPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:15:02 -0400
Message-ID: <4E33A17B.2050008@01019freenet.de>
Date: Sat, 30 Jul 2011 08:15:23 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Firefox/5.0 SeaMonkey/2.2
MIME-Version: 1.0
To: Huajun Li <huajun.li.lee@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, acho@novell.com,
        linux-kernel@vger.kernel.org, lud <linux-usb@vger.kernel.org>,
        usb-storage@lists.one-eyed-alien.net,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 3.0: broken ums_eneub6250
References: <j0um5s$4l4$1@ID-44327.news.uni-berlin.de> <20110729181418.fa4af78f.rdunlap@xenotime.net> <CA+v9cxbKKxPg29q5Jr3Lf+JOrdQeYhrPqFm4TtK9=c1Xoq3CUw@mail.gmail.com>
In-Reply-To: <CA+v9cxbKKxPg29q5Jr3Lf+JOrdQeYhrPqFm4TtK9=c1Xoq3CUw@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

Huajun Li schrieb:
> Hi Dunlap and all, The root cause may be the firmware of ENE card
> reader is not integrated yet. You known, after the codes merged from
> staging/keucr into usb-storage, its HEX formated firmware codes were
> removed, and they should go to firmware tree.
> 
> Currently, acho@novell.com toke efforts to get these firmware
> license and pushed the patch to dwmw2@infradead.org, I thinks the
> patch is pending now.
> 
> Yes, the perfect way to fix the issue is waiting the firmware patch 
> applied soon, but to make your card work at once, I think you could 
> get a copy of the firmware patch from acho@novell.com.  :)

What's the name of the firmware file? I think, there is a repository
somewhere, where I could just get it? Any hints?


Thanks,
Andreas
