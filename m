Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0KZRU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:20:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41922 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0KZRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:20:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MRrXTBwLyjAd1Bx9TBLYM3+LziJMq6Xwr47J6X9KhGFWv0e4xuqG4BUx2Xt8TO0KZs
         Ff8iCFPrfVBESMZCjmQBeS2FnHYL1yBdOPWzoi2wku4rcvA7XOr1fbtzDYYrYH39lbgo
         3aR8IF2nY50QqesVoom0C6BVUF6btkjmr0wqM=
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on printk_pending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1011261109500.13524@router.home>
References: <20101126120235.406766476@de.ibm.com>
	 <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
	 <1290788536.2855.237.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011261038360.13524@router.home>
	 <1290790791.2855.259.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011261109500.13524@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 18:20:51 +0100
Message-ID: <1290792051.2855.265.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 11:11 -0600, Christoph Lameter a écrit :

> I thought sanity tests do not apply for performance testing scenarios?
> 

CONFIG_DEBUG_PREEMPT

> smp_processor_id() is usually a simple per cpu data access and very fast.
> 

Sure, but when its already in a register, its better to use the
register ;)



