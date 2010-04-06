Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0DFVjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0DFVjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:39:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100406213620.28251.90764.stgit@warthog.procyon.org.uk>
References: <20100406213620.28251.90764.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       npiggin@suse.de, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make out [ver #2]
Date: Tue, 06 Apr 2010 22:38:33 +0100
Message-ID: <28335.1270589913@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With this patch, I don't think I should need to modify FS-Cache.  There's the
possibility that we may think the page that we want to release is still being
written to the disk, but that should merely defer releasepage().

David
