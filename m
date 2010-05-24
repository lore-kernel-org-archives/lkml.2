Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0EXO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0EXO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:28:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100521093552.e4a77963.akpm@linux-foundation.org>
References: <20100521093552.e4a77963.akpm@linux-foundation.org> <20100323144836.GA10420@redhat.com> <22494.1274436496@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] misc: don't use sig->count
Date: Mon, 24 May 2010 15:28:22 +0100
Message-ID: <25350.1274711302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Sure, unless there's a reason not to do this?

Not that I know of.  I was just checking (I'd like to get them out of my patch
stack one way or another).

David
