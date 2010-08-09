Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0HIM3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab0HIM3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:29:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100808193039.20403.67383.stgit@warthog.procyon.org.uk>
References: <20100808193039.20403.67383.stgit@warthog.procyon.org.uk>
To: torvalds@osdl.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wang Lei <wang840925@gmail.com>
Subject: Re: [PATCH] AFS: Implement an autocell mount capability
Date: Mon, 09 Aug 2010 13:28:23 +0100
Message-ID: <2391.1281356903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> Implement the ability for the root directory of a mounted AFS filesystem to
> accept lookups of arbitrary directory names, to interpet the names as the
> names of cells, to look the cell names up in the DNS for AFSDB records and
> to mount the root.cell volume of the nominated cell on the pseudo-directory
> created by lookup.

Hold this patch for the moment.  One of the prerequisite patches hasn't made
it upstream yet.

David
