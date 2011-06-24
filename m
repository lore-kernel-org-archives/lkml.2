Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1FXMUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:20:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35607 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1FXMUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <201106241326.27593.hverkuil@xs4all.nl>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>
	<4E04732A.3060305@infradead.org>
	<201106241326.27593.hverkuil@xs4all.nl>
Date: Fri, 24 Jun 2011 08:20:28 -0400
Message-ID: <BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applications are certainly using it. I know this for a fact for the ivtv driver where
> feature improvements are marked that way.
>
> Without more research on how this is used I am not comfortable with this.
>
> Regards,
>
>        Hans

MythTV has a bunch of these too (mainly so the code can adapt to
driver bugs that are fixed in later revisions).  Putting Mauro's patch
upstream will definitely cause breakage.

Also, it screws up the ability for users to get fixes through the
media_build tree (unless you are increasing the revision constantly
with every merge you do).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
