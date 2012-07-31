Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2GaSri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2GaSrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:47:36 -0400
From: Paul Moore <pmoore@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 1.0.0 released
Date: Tue, 31 Jul 2012 14:47:28 -0400
Message-ID: <1406534.aFrnQ02PR9@sifl>
Organization: Red Hat
User-Agent: KMail/4.8.4 (Linux/3.4.5-gentoo; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to announce the second release of the libseccomp library.  The 
libseccomp library provides an easy to use, platform independent, interface to 
Linux's enhanced syscall filtering mechanism.

 * http://sourceforge.net/projects/libseccomp
 * http://sf.net/projects/libseccomp/files/libseccomp-1.0.0.tar.gz/download

Significant changes in this release include:

 * The API is now context-aware; eliminating all internal state but breaking
   compatibility with the initial 0.1.0 release.  The major version number has
   been bumped with this release to allow both version to coexist on the same
   system.
 * Added support for multiple, simultaneous build jobs and verbose build
   output.  This should not affect individual developers, but it should make
   life easier for packagers.

Once again, thanks to everyone who has submitted suggestions, provided testing 
help, and contributed patches to the project.

-- 
paul moore
security and virtualization @ redhat

