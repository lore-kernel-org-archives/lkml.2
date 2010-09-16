Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0IPJ7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0IPJ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:59:09 -0400
Date: Thu, 16 Sep 2010 11:53:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916095310.GG20864@redhat.com>
References: <20100915185417.GA3924@redhat.com>
 <20100916090256.GU3008@redhat.com>
 <20100916091054.GA20864@redhat.com>
 <20100916092553.GV3008@redhat.com>
 <4C91E75B.6010704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C91E75B.6010704@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:46:03AM +0200, Avi Kivity wrote:
>  On 09/16/2010 11:25 AM, Gleb Natapov wrote:
> >>
> >>  MSI only appeared in rhel6, older guests still use level interrupts.
> >So they are already slow for other reasons.
> >
> 
> Exactly, for example they need to exit to userspace to ack the
> interrupt.  That's far slower than the workqueue.

Well, this is not exactly comparable: you might get
same irq asserted multiple times and only deasserted once.


> -- 
> error compiling committee.c: too many arguments to function
