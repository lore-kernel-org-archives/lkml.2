Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0IUS0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:26:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab0IUS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=m/GvPOp4rRHQLNwCE1Ys/HCZLGYrpZbBhrmStJOAPB/N501nCrLHAtRUzyPp5wKSEE
         QPaUKoGMPn69/rZQNqHd+XnZAJ8Z57SYDt0D5Jo5DYP/PrBQ9FP18sKYYFKB5Xv7W+dh
         1nNBBwxo/c3idBZC/4eCBtyypzXKXG28ZKNso=
Date: Tue, 21 Sep 2010 20:26:07 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Message-ID: <20100921202607.2b46ffca@gmail.com>
In-Reply-To: <201009171550.48480.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009171002.09187.simon.farnsworth@onelan.co.uk>
	<4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
	<201009171550.48480.anarsoul@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010 15:50:43 +0300
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> > Vasily, can you try the qos workaround on your machine and see if it works
> > too?
> > 
> > Thanks,  
> 
> Just give me a patch :)

Me too...

I've a laptop with 945GM (Asus x5dij) and with 2.6.32+ kernels I'm
having random, but not frequent, screen flickering problems (for some
reasons 2.6.31 works fine).

Problem goes away with "nohz=off".

I'll try with "processor.max_cstate=?" and see if that works too.

Bye,

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
