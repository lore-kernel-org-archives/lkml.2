Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0FASwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:52:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0FASwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:52:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1275289144-28782-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1275289144-28782-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, jens.axboe@oracle.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] remove needless ISA_DMA_THRESHOLD
Date: Tue, 01 Jun 2010 19:51:08 +0100
Message-ID: <4959.1275418268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Architectures don't need to define ISA_DMA_THRESHOLD anymore.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David Howells <dhowells@redhat.com>
