Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2FTI5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:57:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44480
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936Ab2FTI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:57:32 -0400
Date: Wed, 20 Jun 2012 04:57:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 1/2]block: handle merged discard request
Message-ID: <20120620085724.GA26295@infradead.org>
References: <20120316073213.656519005@fusionio.com>
 <20120316073512.485027511@fusionio.com>
 <20120320162157.GE17071@redhat.com>
 <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
 <4F69C62C.7020604@kernel.org>
 <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:53:02PM -0400, Martin K. Petersen wrote:
> Nope, it's broken. But if you check my write same patches you'll see
> that I actually return the correct completion size there.
> 
> There are several additional commands in the pipeline where the 1:1
> mapping between DMA size and block range is invalid. I want to get rid
> of the 1:1 assumption in general so we can handle any command without
> these evil workarounds.

What's the progress on getting these issues sorted out?

