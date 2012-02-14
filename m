Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2BNQEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:04:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2BNQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:03:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1329200354.3806.1.camel@phoenix>
References: <1329200354.3806.1.camel@phoenix>
To: Axel Lin <axel.lin@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@us.ibm.com>,
        Thomas Meyer <thomas@m3y3r.de>, Anton Blanchard <anton@samba.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] RxRPC: Fix kcalloc parameters swapped
Date: Tue, 14 Feb 2012 16:03:28 +0000
Message-ID: <18099.1329235408@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> wrote:

> The first parameter should be "number of elements" and the second parameter
> should be "element size".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Not that it matters, I think, but let's be consistent...

Acked-by: David Howells <dhowells@redhat.com>
