Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0LEOfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:35:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64581 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab0LEOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:35:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=jWVVvaXlW+UpyXiFiZE0z0zXe/Zreyrcmaz4ytCj7bDWhhpzjCyZz1kb46Kz3J0vVq
         aqsQECKCxDUnyoesT60lIv5tNlWO8EvZXcG5h6NVO4KTGAKfxjqqcGgRQz3y8HyCk3uQ
         dWGnkanYLIBXHuBAJFUtUwLFafchHjn/q/D2c=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 5 Dec 2010 15:34:59 +0100
Message-ID: <AANLkTi=D7KxAZxAjjSNTRiQ4nOBcwhzAor23ik-U9mcn@mail.gmail.com>
Subject: man-pages-3.32 and "The Linux Programming Interface" are released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Two announcements this time:

1) I've released man-pages-3.32.tar.gz - man pages for Linux
2) My Linux system programming book, "The Linux Programming Interface"
is now available.

Some details of both of these releases are given below.

===

This man-pages-3.32 release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/12/man-pages-332-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
A few changes in this release that may be of interest to readers of this
list are listed below.

===

My book, "The Linux Programming Interface" (TLPI) has just been
published (No Starch Press, http://nostarch.com/tlpi/ ).

TLPI is a detailed guide and reference for system programming on Linux
and UNIX systems--with 1552 pages, 115 diagrams, 88 tables, nearly 200
example programs, and over 200 exercises.

The TLPI web site ( http://man7.org/tlpi/ ) contains the detailed
table of contents, preface, sample chapters, bibliography, and index
for download. It also provides complete source code and a more
detailed description of the book.

TLPI has been very positively reviewed. You can find
pointers to reviews at http://www.man7.org/tlpi/reviews/

For information on ordering TLPI, see
http://www.man7.org/tlpi/index.html#ordering

===

Cheers,

Michael

==================== Changes in man-pages-3.32 ====================

New and rewritten pages
-----------------------

pthread_sigqueue.3
    Michael Kerrisk
        New page documenting ptrhead_sigqueue()
            pthread_sigqueue() is new in glibc 2.11 (requires a kernel with
            rt_tgsigqueinfo(), added in Linux 2.6.31).


Newly documented interfaces in existing pages
---------------------------------------------

readv.2
    Michael Kerrisk
        Add documentation of preadv() and pwritev()
            The preadv() and pwritev() system calls were added in
            Linux 2.6.30.


chown.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

fcntl.2
    Michael Kerrisk
        Add notes on fcntl64()

fstatat.2
    Michael Kerrisk
        Add NOTES on fstatat64(), the name of the underlying system call

getdents.2
    Michael Kerrisk
        Added notes on getdents64()

getgid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

getgroups.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

getresuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

getrlimit.2
    Michael Kerrisk
        Add example program for prlimit()

getuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

open.2
    Ivana Hutarova Varekova
        O_EXCL can be used without O_CREAT for block devices
            Since Linux 2.6 there is a possibility to use O_EXCL without
            O_CREAT. See patch: http://lkml.org/lkml/2003/8/10/221.

pread.2
    Michael Kerrisk
        Add notes on pread64() and pwrite64()
            See https://bugzilla.kernel.org/show_bug.cgi?id=23072
    Michael Kerrisk
        SEE ALSO: add readv(3)

sendfile.2
    Michael Kerrisk
        Add notes on sendfile64()

setfsgid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

setfsuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

setgid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

setresuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

setreuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

setuid.2
    Michael Kerrisk
        Add NOTES explaining 32-bit system calls added in Linux 2.4

statfs.2
    Michael Kerrisk
        Add notes on statfs64() and fstatfs64()

swapon.2
    Hugh Dickins
        Document SWAP_FLAG_DISCARD and discarding of swap pages

truncate.2
    Michael Kerrisk
        Add notes on truncate64() and ftruncate64()

memcpy.3
    Michael Kerrisk
        Change "should not overlap" to "must not overlap"
            glibc 2.12 changed things so that applications that use memcpy() on
            overlapping regions will encounter problems. (The standards have
            long said that the behavious is undefined if the memory areas
            overlap.)

            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=603144
            In reference of http://lwn.net/Articles/414467/
            and http://article.gmane.org/gmane.comp.lib.glibc.alpha/15278

pthreads.7
    Michael Kerrisk
        Added description of async-cancel-safe functions

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
