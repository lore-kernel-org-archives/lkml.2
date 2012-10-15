Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2JOLOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:14:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2JOLN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:13:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121011232044.GZ16230@one.firstfloor.org>
References: <20121011232044.GZ16230@one.firstfloor.org> <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-4-git-send-email-andi@firstfloor.org> <CAMuHMdWJCLnWpuNFvQQSJU0w4fQLg6rYbDOQF2But1__NrgiAg@mail.gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: dhowells@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@hansenpartnership.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/31] sections: Fix section conflicts in arch/frv
Date: Mon, 15 Oct 2012 12:13:43 +0100
Message-ID: <30148.1350299623@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

> Does this fix it? -Andi

Works for me.  I've added it to my FRV fixup patches.

David
