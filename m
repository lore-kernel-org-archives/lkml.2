Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1FFSt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:49:26 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:43391 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1FFStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:49:22 -0400
Subject: Re: [PATCH 2/5] Rename two struct members called "cic_list"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 06 Jun 2011 20:49:09 +0200
In-Reply-To: <4DEC431E.2020309@kernel.dk>
References: <1307291188.8545.43.camel@t41.thuisdomein>
	 <4DEC431E.2020309@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307386160.1841.13.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 05:01 +0200, Jens Axboe wrote:
> I honestly don't see much point to this. It's a list...

Well, at some point one loses ones patience trying to not overlook the
difference between
	ioc->cic_list
and
	cic->cic_list

Perhaps it has to do with my perspective (ie, just reading this code to
fix a bug) not being your perspective (ie, reading code you've
maintained for some time now).


Paul Bolle

