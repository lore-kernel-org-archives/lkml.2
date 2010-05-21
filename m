Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0EUKIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:08:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0EUKI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:08:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100323144836.GA10420@redhat.com>
References: <20100323144836.GA10420@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] misc: don't use sig->count
Date: Fri, 21 May 2010 11:08:16 +0100
Message-ID: <22494.1274436496@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> According to grep, get_nr_threads() becomes the only user of sig->count.

Are these two patches going upstream in this window?

David
