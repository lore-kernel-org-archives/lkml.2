Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2BHMUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:20:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab2BHMUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:20:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1328677745-20121-22-git-send-email-hpa@zytor.com>
References: <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
Date: Wed, 08 Feb 2012 12:20:26 +0000
Message-ID: <8328.1328703626@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> However, they are nothing but standard (nonatomic) bit operations, and
> we already have optimized versions of bit operations in the kernel.
> We can't include <linux/bitops.h> in <asm/posix_types.h> but we can
> move the definitions to <linux/time.h> and define them there in terms
> of standard kernel bitops.

Why linux/time.h?  Why not linux/poll.h?  That would seem a more appropriate
place for them.

David
