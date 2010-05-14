Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab0ENT4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:56:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51457 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689Ab0ENT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tjur2X/wxAcyG+4ArBX3BG07jcWMSGPuU0H80Sbns0RZkC9ZJCsnRv+V+oQ/Ym9VD2
         d3wNyfRwhqiAsdhYNghrGSF0s6cCRIfNO4mLcX6kyrxyhFjGrQhpQo1MBLuOyRFseaw4
         aKgIbXQfmwbrIX/oiexXu6VWxLlE2kWa+hpeg=
MIME-Version: 1.0
Date: Fri, 14 May 2010 14:56:08 -0500
Message-ID: <AANLkTim6lwu7Vt72PYSQ7r2swXkEIIYXYeo9z22PKJcz@mail.gmail.com>
Subject: Re: [PATCH -V7 4/9] vfs: Add open by file handle support
From: Steve French <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think open by handle will turn out to be useful, but in discussing
various "duplicate inode number" checks that we are having to add to
cifs, it reminded me that we probably need a "generation number" or
some equivalent (birth time is probably good enough as well) to be
able to tell the case where a file is deleted and new file is created
reusing the same inode number (eventually Samba needs to return this
to posix clients if inode numbers are to be useful - and I don't know
how to tell Samba how to get birth time or generation numbers out of
stat in userspace)

-- 
Thanks,

Steve
