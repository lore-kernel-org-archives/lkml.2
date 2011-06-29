Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1F2Wge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 18:36:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1F2Wgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 18:36:31 -0400
Date: Wed, 29 Jun 2011 15:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] KEYS: Fix error handling in construct_key_and_link()
Message-Id: <20110629153620.e00e9ef2.akpm@linux-foundation.org>
In-Reply-To: <20110621133205.32304.82464.stgit@warthog.procyon.org.uk>
References: <20110621133205.32304.82464.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 14:32:05 +0100
David Howells <dhowells@redhat.com> wrote:

> BUG: unable to handle kernel paging request at ffffffffffffff84
> 
> ...
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Jeff Layton <jlayton@redhat.com>

So... this was a way to force 2.6.39.x users to upgrade to 3.0.x?
