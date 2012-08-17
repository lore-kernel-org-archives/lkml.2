Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2HQAFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:05:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab2HQAFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:05:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFzDpQmE1n__kaW4unfuzhPstKzp41GseL_AwuE-8_bAig@mail.gmail.com>
References: <CA+55aFzDpQmE1n__kaW4unfuzhPstKzp41GseL_AwuE-8_bAig@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6-rc2
Date: Fri, 17 Aug 2012 01:05:36 +0100
Message-ID: <10034.1345161936@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So, due to travels, the -rc2 release was two weeks instead of the
> usual one. But it's out there now.

Are you still considering my UAPI header patches and Nicholas's tcm_vhost
merge as you mentioned in the -rc1 announcement?  Or are these now in the
category of things that need to wait till the next merge window?


Anyway, I've regenerated my patches again as a new UAPI header appeared in the
last couple of days and another got some additions.  Running:

	git diff uapi-post-split-201208{14,17} -- arch/*/include include |
	diffstat

shows:

 arch/sh/include/cpu-sh2a/cpu/sh7269.h |   36 ++-
 include/linux/vfio.h                  |  357 --------------------------------
 include/uapi/linux/Kbuild             |    1 
 include/uapi/linux/fuse.h             |   19 +
 include/uapi/linux/vfio.h             |  368 ++++++++++++++++++++++++++++++++++
 5 files changed, 412 insertions(+), 369 deletions(-)

The latest regeneration is at tag uapi-post-split-20120817 in the GIT tree
mentioned in my previous pull request.

Thanks,
David
