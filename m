Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1GGXYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:24:24 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51922 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1GGXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:24:23 -0400
X-Sasl-enc: V+1IfvXV2ENp/ZrhxqrlEZzXf5fHRfslCA4zP5rifTTK 1310081062
Date: Thu, 7 Jul 2011 16:11:26 -0700
From: Greg KH <greg@kroah.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        stable@kernel.org
Subject: Re: [PATCH] KEYS: Fix error handling in construct_key_and_link()
Message-ID: <20110707231126.GA5696@kroah.com>
References: <20110629153620.e00e9ef2.akpm@linux-foundation.org>
 <20110621133205.32304.82464.stgit@warthog.procyon.org.uk>
 <22918.1309435191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22918.1309435191@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:59:51PM +0100, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > So... this was a way to force 2.6.39.x users to upgrade to 3.0.x?
> 
> Sorry, I always forget to cc stable.

I got it now, thanks.
