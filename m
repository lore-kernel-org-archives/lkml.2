Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0FUPRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:17:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab0FUPRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:17:09 -0400
Date: Mon, 21 Jun 2010 17:16:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
 CFQ_GROUP_IOSCHED=n
Message-ID: <20100621151647.GA6322@elte.hu>
References: <20100618143947.GA8431@redhat.com>
 <20100620081016.GA5365@elte.hu>
 <20100620225622.GA12368@redhat.com>
 <20100621070517.GA31535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621070517.GA31535@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3741]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] Will try your newer patch too.

Works fine here.

Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
