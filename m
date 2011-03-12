Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1CLTWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 14:22:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38506 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1CLTWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 14:22:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DraCS0gHv2NDmtCpNF5WZI+lABdqGeNhPHpNiGdRjk4ELdD1NK1LtdsKcgqSVjfBWP
         DQJeOMtTgA5rTObwBwPzLMgPhr2NukJXg3ZILJO6NZpExwmT2VNp6zvVhLo4dHuL4hMA
         HBgDiR3yWIjzRsLY+AA5ER4Glafk6PpENNZ+o=
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Indan Zupancic <indan@nul.nu>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
In-Reply-To: <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	 <201103111255.44979.arnd@arndb.de>
	 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	 <4D7AC0FE.8070806@gmail.com>
	 <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Mar 2011 21:22:16 +0200
Message-ID: <1299957736.2332.4.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-12 at 02:33 +0100, Indan Zupancic wrote:
> > I think that you missed the point of the extension.
> >
> > Ric
> 
> The point is clear, it's to synchronize a specific file system instead
> of all of them.
> 
> But actually doing that from a program is harder than it looks, because
> programs work with files, not file systems. To make this feature useful
> the program needs meta information it can't easily get. That was my first
> point.

I had a program, actually a set of programs, which test a file-system.
And this set of programs needed such a feature quite a lot, to sync the
FS which is being tested and nothing else - for both performance reasons
and to put more stress to the FS under testing. We used -o remount, rw
for this - but this forced us to run under root.

IOW, there are programs which take a mount point as an input parameter
and want do things with the whole FS, not only individual files.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

