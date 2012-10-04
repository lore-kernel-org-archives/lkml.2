Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2JDUsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:48:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab2JDUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:48:32 -0400
Date: Thu, 04 Oct 2012 16:48:30 -0400 (EDT)
Message-Id: <20121004.164830.95335113175840606.davem@davemloft.net>
To: dhowells@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <17438.1349380312@warthog.procyon.org.uk>
References: <17438.1349380312@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 04 Oct 2012 20:51:52 +0100

> Can you merge the following branch into the sparc tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Note that there are some fixup patches which are at the base of the branch
> aimed at you, plus all arches get the asm-generic branch merged in too.

When I pull the sparc branch, I get c6x and arm64 commits too.

37d11ab8b478ccb7aa2270666603ca2e5ac4c11d
1c1e436269fe840cdbecfaf397b21778dd276f26

I don't want that going in via the sparc tree, it really
doesn't belong there.
