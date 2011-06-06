Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1FFTNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:13:18 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58493 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab1FFTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:13:17 -0400
Subject: Re: [PATCH 3/5] CFQ: rename ioc_data to last_cic
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jun 2011 21:13:11 +0200
In-Reply-To: <4DEC4342.1070101@kernel.dk>
References: <1307291194.8545.44.camel@t41.thuisdomein>
	 <4DEC4342.1070101@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307387596.1841.24.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 05:02 +0200, Jens Axboe wrote:
> It's really io scheduler agnostic, but cfq is the only user. Lets leave
> the flexibility there.

So that agnosticism and flexibility is unused right now. This might
again have to do with my perspective, but understanding that
	ioc->ioc_data

(which really is rather opaque) basically meant (something like)
	ioc->cic_last

was a bit of an eye opener for me. But you have to maintain this code,
which makes this your decision, obviously.


Paul Bolle

