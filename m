Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1CGOgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:36:45 -0500
Received: from mail.perches.com ([173.55.12.10]:4131 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CGOgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:36:44 -0500
Subject: Re: [PATCH] MAINTAINERS: Add a guideline on notification of new
 userspace API/ABI elements
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
References: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 06:36:43 -0800
Message-ID: <1299508603.20104.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 11:35 +0000, David Howells wrote:
> Add a guideline indicating who to notify about new userspace API/ABI elements,
> such as new system calls or error codes.

Hey David.

Is there some list of files that are more likely to
trigger this?

Maybe add a section like:

USERSPACE ABI/API INTERFACES
L:	linux-api@vger.kernel.org
F:	include/asm-generic/errno*.h
F:	include/linux/capability.h
F:	include/linux/compat.h
F:	include/linux/syscalls.h
F:	include/*/unistd.h

Maybe add some arch wildcards?

F:	arch/*/include/asm/errno.h
F:	arch/*/include/asm/unistd.h

Maybe add fs?

F:	fs/compat*.c

There's probably a bunch of others.
Suggestions?

