Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1FFDB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:01:59 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46900 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1FFDB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:01:57 -0400
Message-ID: <4DEC431E.2020309@kernel.dk>
Date: Mon, 06 Jun 2011 05:01:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/5] Rename two struct members called "cic_list"
References: <1307291188.8545.43.camel@t41.thuisdomein>
In-Reply-To: <1307291188.8545.43.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-05 18:26, Paul Bolle wrote:
> Let's call them io_context.cic_hlist and cfq_io_context.cic_node. That
> should be much less confusing.
> 
> There's also cfq_data.cic_list. It is allowed to keep its name (as it's
> the struct member that's most entitled to that name).

I honestly don't see much point to this. It's a list...

-- 
Jens Axboe

