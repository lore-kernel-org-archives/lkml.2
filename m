Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1FFDDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:03:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1FFDDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:03:12 -0400
Message-ID: <4DEC436B.7040601@kernel.dk>
Date: Mon, 06 Jun 2011 05:03:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] block: rename the return of two functions
References: <1307291197.8545.45.camel@t41.thuisdomein>
In-Reply-To: <1307291197.8545.45.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-05 18:26, Paul Bolle wrote:
> If we rename the return of alloc_io_context() and get_io_context() from
> "ret" to "ioc" the code get's (a bit) more readable and (a lot) more
> grepable.

Agree, it matches the style of other places. Applied.

-- 
Jens Axboe

