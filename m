Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1EFT0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:26:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1EFT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dd5UrG+mwAMwDgjXmb2VvPQA9r0ttuwO0X3RlBxNf+wVhuorqFDzjRwON7c/TfHe7s
         0UII2TD7PP6ixqK7XRssANUz+OUw2vRQ5gZWVw9/zTy/6WyaovmtSwmz3I99QOiDAFbR
         1qeQNBL5dzTDP1F6ZRV4hk5Pc36TzpzEIKjxI=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110506175051.GL11636@one.firstfloor.org>
References: <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
	 <20110506175051.GL11636@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 21:26:43 +0200
Message-ID: <1304710003.2821.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 19:50 +0200, Andi Kleen a écrit :
> On Fri, May 06, 2011 at 07:42:47PM +0200, Eric Dumazet wrote:
> > Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> > 
> > > If you have a better way to make it faster please share it.
> > 
> > Ideally we could use RCU :)
> 
> Hmm, I didn't think my case had a lot of loops in the seqlock -- just
> expensive cache misses -- but I should double check.
> 
> For the lots of loop case we probably need to understand first why you
> iterate that often.

Yep, I'll try to investigate on this

Thanks !


