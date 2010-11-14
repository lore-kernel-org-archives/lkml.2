Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0KNPqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 10:46:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42360 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab0KNPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 10:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=R9h9J2ow8pYfHfoBU4bdHnWUR6x9+lJzRtgSBlro/hzDL/eVtVw88imtIIN+M1DSA5
         NiT24Xr8rNJWz3Q7q4iZxhTX7qxbBr26fI7IACn0LTnsj4vcaW7iiXUo0kuxS3ZsMTna
         zC+dmhj4M0l834gnoisTi50rPz0llIr+w45iU=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 14 Nov 2010 16:45:48 +0100
Message-ID: <AANLkTimp=Had3h7j5sWq_4cPwR5aejeniqtSAXat7zV9@mail.gmail.com>
Subject: man-pages-3.31 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.31.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/11/man-pages-331-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.31 ====================

Newly documented interfaces in existing pages
---------------------------------------------

getrlimit.2
    Michael Kerrisk
        Added documentation of prlimit()
            prlimit() is new in kernel 2.6.36.

inotify.7
    Michael Kerrisk
        Document IN_EXCL_UNLINK
            This flag was added in Linux 2.6.36.
            See kernel commit 8c1934c8d70b22ca8333b216aec6c7d09fdbd6a6.

Changes to individual pages
---------------------------

kexec_load.2
    Michael Kerrisk
        Add kernel version where KEXEC_PRESERVE_CONTEXT first appeared
        Added kernel version number where KEXEC_ON_CRASH first appeared
        Fix copyright
            Make copyright in the name of Intel corporation
        VERSIONS: Fix version number
            kexec_load() was first implemented in 2.6.13, though the entry
            in the system call table was reserved starting in 2.6.7.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
