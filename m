Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1G3Cuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 22:50:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38482 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1G3Cuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 22:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110729181418.fa4af78f.rdunlap@xenotime.net>
References: <j0um5s$4l4$1@ID-44327.news.uni-berlin.de>
	<20110729181418.fa4af78f.rdunlap@xenotime.net>
Date: Sat, 30 Jul 2011 10:50:43 +0800
Message-ID: <CA+v9cxbKKxPg29q5Jr3Lf+JOrdQeYhrPqFm4TtK9=c1Xoq3CUw@mail.gmail.com>
Subject: Re: Linux 3.0: broken ums_eneub6250
From: Huajun Li <huajun.li.lee@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, acho@novell.com
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        linux-kernel@vger.kernel.org, lud <linux-usb@vger.kernel.org>,
        usb-storage@lists.one-eyed-alien.net,
        David Woodhouse <dwmw2@infradead.org>,
        huajun li <huajun.li.lee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dunlap and all,
The root cause may be the firmware of ENE card reader is not
integrated yet. You known, after the codes merged from staging/keucr
into usb-storage, its HEX formated firmware codes were removed, and
they should go to firmware tree.

Currently, acho@novell.com toke efforts to get these firmware license
and pushed the patch to dwmw2@infradead.org, I thinks the patch is
pending now.

Yes, the perfect way to fix the issue is waiting the firmware patch
applied soon, but to make your card work at once, I think you could
get a copy of the firmware patch from acho@novell.com.  :)

Thanks,
--Huajun
