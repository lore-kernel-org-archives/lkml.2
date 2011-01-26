Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1AZSS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:18:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46410 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1AZSS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:18:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IbqAu+t6R+xU2+d9/UJ5P09L3P+h1k7eVHYOUXOSJlwtcA8W+TuXRqu2JwKD85md3/
         XRX+bxkyDRkE7rnwunwpHWqSsF3kdjfh8KSzHcecu1cNtmnjBwTQoo8Jim9hNiBfOIIG
         +Agu1wpS75ckfVHm3Nw6Z2D/uu2eQAR28FGLY=
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1101261001550.14705@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>
	 <1296026298.2633.19.camel@edumazet-laptop>
	 <1296040578.2899.59.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
	 <1296056600.2899.66.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
	 <1296057590.2899.73.camel@edumazet-laptop>
	 <1296058409.2899.81.camel@edumazet-laptop>
	 <20110126172006.GA9568@BohrerMBP.rgmadvisors.com>
	 <1296064311.2899.90.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101261001550.14705@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 19:18:20 +0100
Message-ID: <1296065900.2899.108.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 26 janvier 2011 à 10:06 -0800, Davide Libenzi a écrit :

> Eric, if you look at fs/select.c (~line 925), poll does exactly the same 
> thing as epoll do.
> It too, ignores the eventual return value of poll_select_set_timeout(), so 
> maybe a little bit more optimized ktime_get_ts+timespec_add_ms could make 
> sense.
> 

OK, I'll post a V3 ;)

Thanks


