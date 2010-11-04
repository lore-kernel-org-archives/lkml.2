Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0KDSH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:07:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52120 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0KDSH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NdoJtKLkYRGpeAIBkIyeroN3Y7E1Qq/7kFZiNAQy7vtQ7ieCNbFFGOJ73t+ZMLQIsv
         cGgWQ2W1MopqYEQHpSi4ScHIaU8nOZoo/dS1VxD1zBPKwW4UjqjU+SywSVTwLpMDdJ1o
         AR0VImip8GcR4s6M+34fV9Lb0hk07geuQZojY=
Subject: Re: [PATCH] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1011041257140.8431@router.home>
References: <1288892908.2659.175.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011041257140.8431@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 19:07:21 +0100
Message-ID: <1288894041.21305.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 13:05 -0500, Christoph Lameter a écrit :
> On Thu, 4 Nov 2010, Eric Dumazet wrote:
> 
> >  static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
> >  {
> > -       return kstat_cpu(cpu).irqs[irq];
> > +	return kstat_cpu(cpu).irqs[irq];
> >  }
> 
> Whitespace fixes?
> 
> Looks ok otherwise.
> 
> Reviewed-by: Christoph Lameter <cl@linux.com>


Ah yes, some lines were beginning with seven spaces.

Thanks for the review !


