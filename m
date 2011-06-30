Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1F3MAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1F3MAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:00:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110629153620.e00e9ef2.akpm@linux-foundation.org>
References: <20110629153620.e00e9ef2.akpm@linux-foundation.org> <20110621133205.32304.82464.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] KEYS: Fix error handling in construct_key_and_link()
Date: Thu, 30 Jun 2011 12:59:51 +0100
Message-ID: <22918.1309435191@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So... this was a way to force 2.6.39.x users to upgrade to 3.0.x?

Sorry, I always forget to cc stable.

David
