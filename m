Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2JDV72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:59:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2JDV7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:59:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121004.164830.95335113175840606.davem@davemloft.net>
References: <20121004.164830.95335113175840606.davem@davemloft.net> <17438.1349380312@warthog.procyon.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for sparc
Date: Thu, 04 Oct 2012 22:59:21 +0100
Message-ID: <19190.1349387961@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> When I pull the sparc branch, I get c6x and arm64 commits too.
> 
> 37d11ab8b478ccb7aa2270666603ca2e5ac4c11d
> 1c1e436269fe840cdbecfaf397b21778dd276f26
> 
> I don't want that going in via the sparc tree, it really
> doesn't belong there.

They're at the base of every branch so that I can test those arches on every
branch.  I suppose I could exclude them from unrelated arch branches, or
perhaps better still if I can get Linus to pull them.

David
