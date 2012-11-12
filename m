Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2KLVvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:51:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2KLVvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:51:22 -0500
From: Paul Moore <pmoore@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 1.0.1 released
Date: Mon, 12 Nov 2012 16:51:13 -0500
Message-ID: <2742323.xTGOeEdtc5@sifl>
Organization: Red Hat
User-Agent: KMail/4.9.3 (Linux/3.6.6-gentoo; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to announce a maintenance release for the libseccomp library, 
libseccomp version 1.0.1.  The libseccomp library provides an easy to use, 
platform independent, interface to Linux's enhanced syscall filtering 
mechanism.

 * http://sourceforge.net/projects/libseccomp
 * http://sf.net/projects/libseccomp/files/libseccomp-1.0.1.tar.gz/download

All users of libseccomp are strongly encourage to update to this latest 
release.  Changes in the 1.0.1 release include:

 * Fixes for the following:
 ** memory leaks
 ** small filters, e.g. filtering only a single syscall
 ** filters with syscall arguments
 * Documentation corrections
 * Support for C++ in the header file

Finally, thank you to everyone who has submitted suggestions, provided testing 
help, and contributed patches to the project.

-- 
paul moore
security and virtualization @ redhat

