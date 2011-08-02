Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1HBPHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1HBPHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:07:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: How to handle patches that require regular regeneration
Date: Tue, 02 Aug 2011 16:07:08 +0100
Message-ID: <14954.1312297628@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Having observed your recent complaint:

	http://article.gmane.org/gmane.linux.kernel/1173804

	"But best would be if it was actually tested, and had actually been in
	-next for a week. That is *especially* true when you send me a pull
	request late in the merge window."

And I have a question as how you might prefer to handle some classes of
patchset.

I have a patchset that needs regular regeneration as it scriptually alters all
the header files that are exported to userspace as a first step in cleaning up
the headers preparatory to sorting out the inclusion recursion issues.

	http://git.infradead.org/users/dhowells/linux-headers.git/shortlog/refs/heads/uapi-split

What's the best way to handle a patchset like this?

Do I point Stephen at a script and ask him to run that to create a new tree
for him to pull into linux-next, knowing that you probably won't be able to
pull the tree directly anyway?

I agree that including it in linux-next would be good, but it potentially
sticks a large burden on Stephen:-/

I know the patches compiled with allyesconfig for x86_64, i386 and MIPS with
some disabling in the configuration to handle stuff that was failing anyway.

I've done my best to make sure that the patches don't lose any content, but
occasionally the scripts have to be coached as to the right place to make a
split.

David
