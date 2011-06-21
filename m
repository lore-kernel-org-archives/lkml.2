Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1FUJ1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab1FUJ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:27:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110620164241.ac6b5d2a.akpm@linux-foundation.org>
References: <20110620164241.ac6b5d2a.akpm@linux-foundation.org> <20110615002210.1392.64165.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/uaccess.h needs to #include linux/kernel.h for might_sleep()
Date: Tue, 21 Jun 2011 10:27:31 +0100
Message-ID: <766.1308648451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> uaccess.h doesn't textually refer to might_sleep().

Good point.  Whilst the error occurs in linux/uaccess.h, the actual problem is
in a #define in asm/uaccess.h.

David
