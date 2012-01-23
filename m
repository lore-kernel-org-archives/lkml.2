Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2AWDqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:46:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2AWDqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:46:16 -0500
Message-ID: <4F1CD7C3.701@landley.net>
Date: Sun, 22 Jan 2012 21:45:07 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Perl removal patches for 3.2.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm still using these, and other people are using them (such as the
musl guys), and even though they haven't really changed I had to re-diff
them to eliminate fuzz, so I thought I'd post them here to the list
again so you've all got fresh versions.

These patches remove perl as a build requirement for Linux.  The first
~17 years of Linux versions never required perl to build, then in 2.6.25
Peter Anvin made Linux stop building on a system without perl at the
same time he added the same requirement to klibc and syslinux and
presumably every other project he could; I don't know why.

This yanks it back out again, which is really nice to do in cross
compile environments where you've set up a restricted $PATH so your
build doesn't go "hey, you've got python and tcl and java installed on
the host, let me wire in support for all that to the package you're
building so it won't work without it".

All these patches are available at http;//landley.net/hg/aboriginal in
the "sources/patches" subdirectory too.
