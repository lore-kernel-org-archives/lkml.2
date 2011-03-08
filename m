Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1CHUVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:21:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab1CHUVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:21:09 -0500
Date: Tue, 8 Mar 2011 15:21:01 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110308202100.GA31744@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D761E0D.8050200@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08 2011 at  7:16am -0500,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-03-03 23:13, Mike Snitzer wrote:
> > I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> > kernel, when I try an fsync heavy workload to a request-based mpath
> > device (the kernel ultimately goes down in flames, I've yet to look at
> > the crashdump I took)
> 
> Mike, can you re-run with the current stack-plug branch? I've fixed the
> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
> on schedule event. It's run outside of the runqueue lock now, so
> hopefully that should solve this one.

Works for me, thanks.

Mike
