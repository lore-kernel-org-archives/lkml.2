Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0D1TTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:19:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab0D1TTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:19:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]: mark ptrace_traceme static
In-Reply-To: Oleg Nesterov's message of  Wednesday, 28 April 2010 15:06:52 +0200 <20100428130652.GA31069@redhat.com>
References: <20100201191855.GA11874@lst.de>
	<20100428114541.GA4705@lst.de>
	<20100428130652.GA31069@redhat.com>
X-Shopping-List: (1) Indignant admonishers
   (2) Inconstant remainder soil
   (3) Homestyle wig squirrels
   (4) Majestic miscreants
Message-Id: <20100428191910.1EB7C4F7@magilla.sf.frob.com>
Date: Wed, 28 Apr 2010 12:19:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/28, Christoph Hellwig wrote:
> >
> > Any reason this never made it to Linus?
> 
> The patch is obviously fine, and iirc it was explicitly acked by Roland.

Yup.  We don't have any canonical tree or submission forwarding path that
goes through us for ptrace stuff, we just post the ACKs.  If Andrew/Linus
et al want us to, we can keep a tree of ptrace-related patches on the queue
to go in.  But we haven't heretofore.


Thanks,
Roland
