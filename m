Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1AHNDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:03:07 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37744 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1AHNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:03:05 -0500
X-Greylist: delayed 4475 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jan 2011 08:03:04 EST
Date: Sat, 8 Jan 2011 14:03:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: [RFC] kbuild: generic support for asm-generic
Message-ID: <20110108130302.GA21698@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd et all.

This is my second attempt to provide generic support for
architectures that use existing headers from asm-generic.

With this kbuild will read the file: arch/$ARCH/include/asm-generic

For each file listed in this file a wrapper is generated in
arch/$ARCH/inclue/generated/asm/

The patch include support so headers_install works.

The inspiration came from the unicore32 patchset,
but I redid this to make it more general.

I will follow-up with two patches.
One that implment the functionality.
A second that convert two headers in x86 to use the
new asm-generic stuff (only as an example).

	Sam
