Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2KJM7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 07:59:31 -0500
Received: from stringer.orebokech.com ([88.190.240.207]:35300 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2KJM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 07:59:23 -0500
From: Romain Francoise <romain@orebokech.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not remove vmlinux when cleaning external module
Organization: orebokech dot com
References: <1351509782-12462-1-git-send-email-pawel.moll@arm.com>
Date: Sat, 10 Nov 2012 13:59:21 +0100
In-Reply-To: <1351509782-12462-1-git-send-email-pawel.moll@arm.com> (Pawel
	Moll's message of "Mon, 29 Oct 2012 11:23:02 +0000")
Message-ID: <87fw4hzk9i.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Moll <pawel.moll@arm.com> writes:

> Since commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 "kbuild:
> link of vmlinux moved to a script" make clean with M=<dir>
> argument (so cleaning external module) removes vmlinux,
> System.map and couple of other files from the *main* kernel
> build directory! This not what was happening before and almost
> certainly not what one would expect.

> This patch moves makes the clean target of the script called
> only when !KBUILD_EXTMOD.

Thanks, I have the same problem and this patch fixes it.

Michal, can you pick it up? It's not yet in kbuild.git, it seems.
