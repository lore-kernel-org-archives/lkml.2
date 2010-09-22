Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0IVRNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:13:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57286 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0IVRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=NNv4hqoyX5NogkYkyH5zaJ/dtA4aFQYbJCoUptrBoLtmJH3fZvkPU8qEDxzIMXD5A3
         zmu3lAKgvWFP5Wu4BfjBrpgozCn0oOwnVw7EANkBOF17MjUUu/RQ8NirfaXBCAJVkWiP
         p5TFXF8UJBtX60CxuDeZ8vMuHhYVDFSDzT8Fw=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 22 Sep 2010 19:13:26 +0200
Message-ID: <AANLkTimurFK6syJRZaxzZ7i64t45z5ePqrTKS_epoKCo@mail.gmail.com>
Subject: man-pages-3.27 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.27.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/09/man-pages-327-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.27 ====================

New and rewritten pages
-----------------------

sigevent.7
    Petr Baudis, Michael Kerrisk
        New page to centralize description of sigevent structure
            Several interfaces use this structure. Best to centralize the
            common details in one place. Content taken from the existing
            timerfd_create.2 and mq_open.3 pages, with additions by
            Petr Baudis and Michael Kerrisk.


Newly documented interfaces in existing pages
---------------------------------------------

ip.7
    Jiri Olsa
        Document IP_NODEFRAG
            This option is new in Linux 2.6.36

unix.7
    Michael Kerrisk
        Document SIOCINQ ioctl() operation


Many pages
    Michael Kerrisk
        Add/fix/update feature test macro requirements in SYNOPSIS
            Various changes to:
            * Update feature test requirements to note changes in
              recent glibc releases
            * Correct errors in feature test macro requirements
            * Add feature test macro requirements to pages where
              the requirements were not previously stated.


Changes to individual pages
---------------------------

getrlimit.2
    Michael Kerrisk
        Document units for RLIMIT_RTTIME limit
            This limit is in microseconds

            http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=596492

mount.2
    Michael Kerrisk
        Definitions of various MS_* constants only appeared in glibc 2.12
            See http://sourceware.org/bugzilla/show_bug.cgi?id=11235

stat.2
    Michael Kerrisk
        Update information on nanosecond timestamp fields
            Update feature test macro requirements for exposing these fields.
            Note that these fields are specified in POSIX.1-2008.

rand.3
    Michael Kerrisk
        Clarify description of range of returned value
        Add an example program
        Expand description of rand_r()

random.3
    W. Trevor King
        Update initstate() return value description to match glibc

feature_test_macros.7
    Michael Kerrisk
        Make text on required placement of macros more prominent
            Move the text that notes the requirement that feature test macros
            must be defined before including any header files to the top of
            the page, and highlight the text further, so that the reader will
            not miss this point.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
