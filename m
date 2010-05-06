Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0EFKkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:40:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0EFKkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:40:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1005061242540.23351@tundra.namei.org>
References: <alpine.LRH.2.00.1005061242540.23351@tundra.namei.org> <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/7] KEYS: Fix an RCU warning in the reading of user keys
Date: Thu, 06 May 2010 11:38:54 +0100
Message-ID: <6966.1273142334@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> The final patch does not apply to my tree -- please rebase it.

Your tree is not up to date with respect to Linus's: you're missing the three
patches he pulled in yesterday.

David
