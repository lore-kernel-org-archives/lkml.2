Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0KEQrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:47:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39654 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0KEQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aO25Qd9kspb/ikECBjRpg+zXzLRtI6nzERoJnAaLUuwkwqUKNnbLZCA0rzc3z6CzsF
         XgKuh+6O4T7IzGJEhbpJZERb22xAl7Mqox1OMM9FW2y8NTvb67dBiug+jOVn9g47ooEv
         5mMarK7a/GYPFG4HWeZFeBd9+CZHgEFXMwvVU=
Subject: Re: [PATCH v2] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4CD43497.1020907@kernel.org>
References: <1288892908.2659.175.camel@edumazet-laptop>
	 <1288973210.2882.733.camel@edumazet-laptop>  <4CD43497.1020907@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 17:47:41 +0100
Message-ID: <1288975661.2882.858.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 17:45 +0100, Tejun Heo a écrit :
> Hello,
> 
> On 11/05/2010 05:06 PM, Eric Dumazet wrote:
> > V2: support for !CONFIG_SPARSE_IRQ
> >     No white space changes.
> > 
> > Question : Is dynamic percpu allocator ready at this stage for all
> > arches ? The need is NR_IRQS*4 bytes of percpu memory for 
> > !CONFIG_SPARSE_IRQ
> 
> The earliest is early_irq_init(), right?  If so, percpu allocator is
> up by then on all archs.
> 

OK thats fine then.

Thanks for the clarification Tejun.



