Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0KDFXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:23:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65522 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0KDFXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=B6A+NwzwRgZqwW3Dne2VEue6P7DuxfCYB7bwi195QSmXPyUcDhBvAe//6DmPVbVAZz
         fCRRt9bTXVIAKdM/tIp+RlraGOVCQjLGUXZaI8CvyCK+qYj0sIeXwKAp2ZszYb5D2K2i
         lkWX+eHuEzeZOvD8+6+aXzVxQJ8FvFNTP2m+M=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 4 Nov 2010 06:23:17 +0100
Message-ID: <AANLkTimwxHuMW4TDvFDLfq_+KULcWM84866B2ruafuXk@mail.gmail.com>
Subject: man-pages-3.30 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.30.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/11/man-pages-330-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.30 ====================

New and rewritten pages
-----------------------

kexec_load.2
    Andi Kleen
        New page documenting kexec_load(2)
    Michael Kerrisk
        Add license
    Michael Kerrisk
        Incorporate fixes from Eric W. Biederman
            Eric noted that a few instances of "virtual" should
            be "physical" and noted:

                There is an expectation that at hand off from sys_kexec that
                virtual and physical addresses will be identity mapped. But
                this isn't the old Alpha booting convention where you have
                a virtual address and then you have to parse the page table
                to figure out where your kernel was actually loaded.
    Michael Kerrisk
        Additions and edits by mtk
            Various wording and layout improvements.
            Fixed the name of a constant: s/KEXEC_ARCH_I386/KEXEC_ARCH_386/.
            Added RETURN VALUE and ERRORS sections.
            Added VERSIONS section
            Note that CONFIG_KEXEC is needed
            Removed details of using syscall; the reader can find them in
            syscall(2).
            Added some details for KEXEC_PRESERVE_CONTEXT.
            Revised the text mentioning the kernel header, since it is
            not yet exported, and it's not certain that it will be.

lio_listio.3
    Michael Kerrisk
        New page documenting lio_listio(3)


Newly documented interfaces in existing pages
---------------------------------------------

reboot.2
    Andi Kleen
        Document LINUX_REBOOT_KEXEC

unshare.2
    Michael Kerrisk
        Document CLONE_NEWIPC
    Michael Kerrisk
        Document CLONE_NEWNET
    Lucian Adrian Grijincu
        Improve description of CLONE_NEWNET
            CLONE_NEWNET creates a new network namespace from scratch.
            You don't have anything from the old network namespace in
            the new one. Even the loopback device is new.
    Michael Kerrisk
        Document CLONE_SYSVSEM
    Michael Kerrisk
        Document CLONE_NEWUTS
    Michael Kerrisk
        Relocate discussion of CAP_SYS_ADMIN to CLONE_NEWNS section
            And rewrite the EPERM description to be more general in
            preparation for the new flags to be documented.


Global changes
--------------

Various pages
    Michael Kerrisk
        Add reference to feature_test_macros(7)
            Some pages simply list feature test macro requirements in
            the form:

                #define #GNU_SOURCE
                #include <someheader.h>

            For these pages, add a "See feature_test_macros(7)" comment
            on the "#define" line.

Various pages
    David Prevot
        Use greater consistency in NAME line
        (Remove definite article at start of descriptiive clause.)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
