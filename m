Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0KELTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:19:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39343 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0KELTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jdPqW5EF4rEPMTdFwdz49NyfkFuYqn0CL6nt/pjNPT/OloO//2FovJnIPXpLYuwQqf
         FncTIbZPCggdHfYeRAwhX4eTLT57jCrsXOr/rCQAEuJ0cJ4tRq+ppMQNs1/fkdsvGWrL
         cSyifOXT5S+D3roSQJsM3acJcI+IgetAXBb9o=
Subject: Re: [PATCH] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4CD3BFEC.4080405@kernel.org>
References: <1288892908.2659.175.camel@edumazet-laptop>
	 <4CD3BFEC.4080405@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 12:19:28 +0100
Message-ID: <1288955968.2882.130.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 09:27 +0100, Tejun Heo a écrit :

> Looks good to me although it would be nice to note the white space
> fixes in the comment.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks !

I'll send a V2 anyway, without the white space fixes,
and with better support of !CONFIG_SPARSE_IRQ 



