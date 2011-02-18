Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1BRHaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:30:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1BRH36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:29:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vIRVqDVhpEwR7qaHAAVlksaKVj/LMPEcLaxCxgeRU7GPdD8vHShjVURJs9eMn0Df2h
         NS4UykscUj/vaEGMraOfFAQ9EYWWun5lL1MnDzKYN8q/1VP/8AyQYap4PDx+451FWOiI
         SJKCoLNUE1RUwloIQIRX9/0pVG/4+libyQjJc=
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com, opurdila@ixiacom.com,
        mingo@elte.hu, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1298010320.2642.7.camel@edumazet-laptop>
References: <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	 <m1sjvm822m.fsf@fess.ebiederm.org>
	 <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	 <20110217.203647.193696765.davem@davemloft.net>
	 <1298010320.2642.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 08:29:51 +0100
Message-ID: <1298014191.2642.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 07:25 +0100, Eric Dumazet a écrit :
> Le jeudi 17 février 2011 à 20:36 -0800, David Miller a écrit :
> > 
> > Eric D., please get a final version of the fix posted to netdev and
> > I'll make sure it slithers it's way to Linus's tree :-)
> > 
> > Thanks!
> 
> I believe we can apply Linus patch as is for current linux-2.6
> 
> Then add a second patch for previous kernels (the parts I added), since
> we might had a previous bug, un-noticed ?
> 

I am working on this right now, to make sure "my part" is really needed
for stable teams.

I'll send an update in a couple of hours.

Thanks


