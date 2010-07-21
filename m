Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0GUNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:24:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0GUNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:24:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, arjan@linux.intel.com, oleg@redhat.com,
        axboe@kernel.dk, fweisbec@gmail.com, dwalker@codeaurora.org,
        stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
        mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#6
Date: Wed, 21 Jul 2010 14:23:19 +0100
Message-ID: <21756.1279718599@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> B. General documentation of Concurrency Managed Workqueue (cmwq)
> ================================================================

This should be in Documentation/workqueue.txt or something like that.

David
