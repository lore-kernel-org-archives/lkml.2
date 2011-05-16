Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1EPPar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:30:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1EPPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PjkUQ8v6qSougAjZuUfQqYpHJNooZ/DUgTbcNiGYz66qptLgaXJBpicAjsUdxxe6Hi
         yhC8WBzwlQQGf19XaHSF5d8+WVxYpfGUACOcAEj01xKSrf8gKc5dMU41hVOTzyByS9K7
         p7cWP4cnDPP+tH9+ycM7IW9m0LngpyiIoV+Ms=
Subject: Re: [PATCH v2] posix-timers: RCU conversion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
In-Reply-To: <4DD13E49.6070508@redhat.com>
References: <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <1301849660.2837.211.camel@edumazet-laptop>
	 <1301940501.2319.25.camel@work-vm>  <20110405144836.GA17490@redhat.com>
	 <1302016682.3171.19.camel@edumazet-laptop>  <4DD13E49.6070508@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 17:30:38 +0200
Message-ID: <1305559838.2898.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 18:10 +0300, Avi Kivity a écrit :
> On 04/05/2011 06:18 PM, Eric Dumazet wrote:
> > [PATCH v2] posix-timers: RCU conversion
> >
> 
> <snip>
> 
> Andrew, I see this in -mmotm, but I see v1, not v2.
> 

Good catch, thanks

To be fair, v1 should work well too ;)


V2 : rcu_head put in the 'it' union, as Oleg suggested.



