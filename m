Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab1CCC0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:26:51 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:36244 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932203Ab1CCC0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:26:49 -0500
Message-ID: <4D6EFC80.6060600@lougher.demon.co.uk>
Date: Thu, 03 Mar 2011 02:27:12 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [ANN] Squashfs tools 4.2 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm pleased to announce the release of Squashfs tools 4.2.  This release
adds support for XZ compression, and filesystem support for compression
specific options (needed for XZ -dict-size and -Xbcj options).  There's
also the usual minor extra features and bug fixes.

The release can be downloaded from http://sourceforge.net/projects/squashfs.

1. Filesystem improvements:

	1.1 Added XZ compression.
	1.2 Added compression options support

2. Miscellaneous improvements/bug fixes.

	2.1 Add missing NO_XATTR filesystem flag to indicate no-xattrs
	    option was specified and no xattrs should be stored when
	    appending.
	2.2 Add suppport in Unquashfs -stat option for displaying
	    NO_XATTR flag.
	2.3 Remove checkdata entry from Unsquashfs -stat option if a 4.0
	    filesystem - checkdata is no longer supported.
	2.4 Fix appending bug when appending to an empty filesystem - this
	    would be incorrectly treated as an error.
	2.5 Use glibc sys/xattr.h include rather than using attr/xattr.h
	    which isn't present by default on some distributions.
	2.6 Unsquashfs, fix block calculation error with regular files when
	    file size is between 2^32-block_size+1 and 2^32-1.
	2.7 Unsquashfs, fix sparse file writing when holes are larger than
	    2^31-1.
	2.8 Add external CFLAGS and LDFLAGS support to Makefile, and allow
	    build options to be specified on command line.  Also don't
	    over-write passed in CFLAGS definition.
	
Phillip

