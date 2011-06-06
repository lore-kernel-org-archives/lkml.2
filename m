Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1FFDCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:02:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46908 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab1FFDCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:02:32 -0400
Message-ID: <4DEC4342.1070101@kernel.dk>
Date: Mon, 06 Jun 2011 05:02:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] CFQ: rename ioc_data to last_cic
References: <1307291194.8545.44.camel@t41.thuisdomein>
In-Reply-To: <1307291194.8545.44.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-05 18:26, Paul Bolle wrote:
> Set its type to struct cfq_io_context too.

It's really io scheduler agnostic, but cfq is the only user. Lets leave
the flexibility there.

-- 
Jens Axboe

