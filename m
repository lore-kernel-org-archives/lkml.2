Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0IOSmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:42:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38089 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab0IOSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=fBaUNk3juE2i1W144qGnomeJHaBO59GHnjnGH4i/0VsxtYhPfcELOwhjlb8cM/TK0O
         K+XZiJprTGL3NZHab9uUeG4do6SH+hgDJXTBV44L2rdrwxnP2z7AO6sopKPpvNnpKSAb
         +CimUa/hDRtAbSAVv9bbykEIMTTAfzWpv8LpA=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 15 Sep 2010 20:41:44 +0200
Message-ID: <AANLkTim1frqcmW7xLvOYkm75+Aci5CzaK3TfB=7_+txb@mail.gmail.com>
Subject: man-pages-3.26 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.26.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/09/man-pages-326-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
This release mainly contains minor fixes to existing pages.
A few changes that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.26 ====================

Newly documented interfaces in existing pages
---------------------------------------------

eventfd.2
    Michael Kerrisk
        Document EFD_SEMAPHORE
            Document the EFD_SEMAPHORE flag, added in kernel 2.6.30.
            Also restructured some parts of the text to fit with the
            addition of the EFD_SEMAPHORE text.

Changes to individual pages
---------------------------

sysfs.2
    Michael Kerrisk
        Clarify that this syscall is obsolete.
            And strengthen recommendation to use /proc/filesystems instead.

tzfile.5
    Michael Kerrisk
        Add information on version 2 format timezone files
            Updated using information from the tzcode 2010l release at
            ftp://elsie.nci.nih.gov/pub.
            (It's an open question whether or not a version of tzfile.5
            should live independently in man-pages. It was added to the
            man-pages set many years ago. For now, I'll follow a
            conservative course that causes least pain to downstream,
            by continuing to maintain a separate copy in man-pages.)

            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594219
