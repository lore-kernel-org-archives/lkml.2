Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1CVKAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:00:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1CVKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mbr20lY95vU2YhMdgxT6U/iBquLNu25P4BrAxts6Q7sL391YtIKkiXXaTqBBy1iwVt
         yGNFwEEM8XwzlvmTdtdsNidrPIXpGRk0SG9FbjwuB7ur2qA7uQh1g5JfQCWNLgL3WGNS
         wgANgALCrgImQ7lm8QIS7oau4kBpni8hsPvGA=
Subject: Re: [slab poison overwritten] Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
In-Reply-To: <20110322095638.GA26130@elte.hu>
References: <20110320.195156.226769634.davem@davemloft.net>
	 <20110321125320.GA23490@elte.hu>
	 <1300714346.2884.284.camel@edumazet-laptop>
	 <20110321161528.GA28580@elte.hu> <20110321164238.GA5303@elte.hu>
	 <20110321173941.GB3892@elte.hu> <1300730838.2884.578.camel@edumazet-laptop>
	 <1300738540.2837.5.camel@edumazet-laptop>  <20110322095638.GA26130@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 11:00:39 +0100
Message-ID: <1300788039.3084.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 mars 2011 à 10:56 +0100, Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > [PATCH] ipvs: fix a typo in __ip_vs_control_init()
> 
> This fix and Simon's:
> 
>   IPVS: Use global mutex in ip_vs_app.c
> 
> Did the trick here, the IPVS related SLAB corruptions are now gone.
> 
> Thanks guys!

Thanks for testing Ingo ;)



