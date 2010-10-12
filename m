Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0JLGEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:04:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0JLGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=CT+hrp9GsC+jlvd95Sybc3Jo3IvWc5COyxlC8wzdZiM4SC6oOVIcw4H8DB1qzrTcfw
         isx+LFl28srxb5nYdkKlSCgQLVWuHX/puGDHfsSyzG+bEQdAeWEqVy43DuHmDF7Va84P
         GKTROMM+waZ9cXh7w8F+me/HmQ/4yzzpP19co=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 12 Oct 2010 08:03:53 +0200
Message-ID: <AANLkTin=ArHbVNUHXwe0HLOcW9iDXujJuwA2Ku-Scu-D@mail.gmail.com>
Subject: man-pages-3.28 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.28.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/10/man-pages-328-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.28 ====================

New and rewritten pages
-----------------------

getaddrinfo_a.3
    Petr Baudis
        New page documenting getaddrinfo_a()
            The page also documents gai_suspend(), gai_cancel(),
            and gai_error().

aio.7
    Michael Kerrisk
        New page providing an overview of POSIX asynchronous I/O


Newly documented interfaces in existing pages
---------------------------------------------

exec.3
    Michael Kerrisk
        Document execpe()
            This function was added to glibc in version 2.11.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
