Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1CQNRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:17:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1CQNRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xXVyDEQFH7r6iZa/HoDBUES5CUhRc5SyUCZK5NEYbBi3uorOJccJyDDoFYTqMLv1Hr
         P4xA8096wJLsPySzx32X6Y/I7HoCqq+bIsBlsGXn/NGS6GSsJsqP0an7P2DB43n/SzBl
         X0ynCUlNsOTTnzyCpk8RRb70sAGKtihH/qq4I=
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
In-Reply-To: <158286.40597.qm@web37607.mail.mud.yahoo.com>
References: <158286.40597.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 15:17:51 +0200
Message-ID: <1300367871.7887.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 23:41 -0700, Alex Dubov wrote:
> > 
> > Do you believe that any other driver is likely to ue the
> > sg
> > infrastructure which this patch adds?  Should those
> > additions be 
> > internal to the memstick code, at least for now?
> > 
> 
> Considering the comments from Fujita and James, I suppose it will be best
> for now to fold the new sg functions into the memstick patch and
> investigate how the block layer functionality can be used to a greater
> utility at some later time.

I am thinking the same thing.
If the unusual sg code is a problem, I'll think of something later to
improve it, heck I can even completely rip it off and just use kernel
pointers, relying on block core to bounce for high-mem situations.
Since its a driver for a legacy hardware, mostly provided for
completeness, the performance difference shouldn't be much.


I think its ok to merge the code with folded sg code _for_ now, and then
I will send patches to address this point you didn't like.


OK?

Best regards,
	Maxim Levitsky 

