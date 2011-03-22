Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1CVHwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 03:52:15 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36599 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1CVHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 03:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=A0ijOQEul1WsZgnX4rq/pZu6LMrhQ7fdJzjLpVgpUEH9ew4+SXIQAyH0lJZAVus5TK
         rQ65e9Oq3mgO9Mhmgicx8achwuYgRuWq2w42e8OU8UFhgLS8Ak4SXyP0oBa32M7oHC/7
         OBiuo49JhuBkKHuYQQXK9q53l/W9HbaDBstl8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjmdi8sFTTjSPerOVgHQ+pjjwwMvCUX3AJ16At@mail.gmail.com>
References: <AANLkTimjmdi8sFTTjSPerOVgHQ+pjjwwMvCUX3AJ16At@mail.gmail.com>
Date: Tue, 22 Mar 2011 08:52:12 +0100
Message-ID: <AANLkTimxrdhhukoVP76c4PUzeWsKOEy-_bHOgCCFabxc@mail.gmail.com>
Subject: [bisect] kernel 2.6.38 regression with root nfs mounting
From: Belisko Marek <marek.belisko@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: also lkml

After update from 2.6.38-rc8 to 2.6.38 is mounting rootfs over nfs not possible.
Log:
VFS: Mounted root (nfs filesystem) on device 0:14.
Freeing init memory: 132K
nfs: server 10.146.1.21 not responding, still trying
nfs: server 10.146.1.21 not responding, still trying

This is never ending. I make short bisect (not too much commits
between versions)
and bad commit was reported: 53d4737580535e073963b91ce87d4216e434fab5

NFS: NFSROOT should default to "proto=udp"

I've tested on mini2440 board (DM9000, static IP).
Is there some missing option or something else to be checked?

Regards,

marek

--
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
