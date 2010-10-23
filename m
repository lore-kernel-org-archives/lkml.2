Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0JWRy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:54:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab0JWRy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:54:58 -0400
Date: Sat, 23 Oct 2010 19:54:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq: improve fsync performance for small files
Message-ID: <20101023175450.GA31667@elte.hu>
References: <201007202209.04627.czoccolo@gmail.com>
 <AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
 <4C976060.1010008@kernel.dk>
 <AANLkTi=VZ0-ysHZ1oqK6b0DsohgD8G65UY=_tUfyK7bh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=VZ0-ysHZ1oqK6b0DsohgD8G65UY=_tUfyK7bh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corrado Zoccolo <czoccolo@gmail.com> wrote:

> Hi Jens,
> I've not seen this patch in your pull request to Linus for .37.
> Any problem with it during test?

Your improvement seems to be upstream:

  749ef9f: cfq: improve fsync performance for small files

Thanks,

	Ingo
