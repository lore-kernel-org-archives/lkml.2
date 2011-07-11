Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab1GKONx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694Ab1GKONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:13:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110711134147.GA6853@infradead.org>
References: <20110711134147.GA6853@infradead.org> <20110711132057.14641.36229.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, autofs@linux.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] VFS: Fix automount for negative autofs dentries
Date: Mon, 11 Jul 2011 15:13:41 +0100
Message-ID: <16882.1310393621@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> would do the same.

But is much less obvious.  The LOOKUP_FOLLOW flag is the primary reason for
this statement.  The rest are subordinate and would be wholly irrelevant if
LOOKUP_FOLLOW was to be removed from the list.

David
