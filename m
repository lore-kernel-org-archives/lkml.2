Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab2FHOwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:52:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760705Ab2FHOvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:51:53 -0400
From: Paul Moore <pmoore@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 0.1.0 released
Date: Fri, 08 Jun 2012 10:51:38 -0400
Message-ID: <1485416.ktZgn4r1kg@sifl>
Organization: Red Hat
User-Agent: KMail/4.8.3 (Linux/3.3.7-gentoo; KDE/4.8.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the release of Linux 3.5-rc1 and the inclusion of the enhanced seccomp 
patches (seccomp mode 2), I'd like to announce the first release of the 
libseccomp library. As mentioned previously here, and on LWN.net[1], the 
libseccomp library provides an easy to use, platform independent, interface to 
Linux's syscall filtering mechanism.

 * http://sourceforge.net/projects/libseccomp
 * http://downloads.sf.net/project/libseccomp/libseccomp-0.1.0.tar.gz

Thanks to everyone who has submitted suggestions, provided testing help, and 
contributed code to the project.

[1] http://lwn.net/Articles/494252

-- 
paul moore
security and virtualization @ redhat

