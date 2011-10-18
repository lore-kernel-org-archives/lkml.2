Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1JRTPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:15:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1JRTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:15:38 -0400
Date: Tue, 18 Oct 2011 15:14:21 -0400 (EDT)
Message-Id: <20111018.151421.864660896119319431.davem@davemloft.net>
To: rientjes@google.com
Cc: hch@infradead.org, jwboyer@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
	<20111018065852.GA6056@infradead.org>
	<alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 12:14:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Tue, 18 Oct 2011 01:07:38 -0700 (PDT)

> On Tue, 18 Oct 2011, Christoph Hellwig wrote:
> 
>> > The stable@kernel.org email address has been replaced with the
>> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
>> > reference the new list instead of the semi-defunct email alias.
>> 
>> Does this mean it already stopped working?  I recently sent pathces
>> there but neither got an ACK nor a bounce or similar.
>> 
> 
> It was bouncing (and noticably so) as of a week ago but I believe hpa has 
> since setup an alias to point to stable@vger.kernel.org.  Linus cc'd his 
> own commit to it yesterday, a84a79e4d369, so as long as you didn't get a 
> bounce email it should have gone through.

Not true.  VGER eats them silently because the forward from
stable@kernel.org contains headers that are commonly found in
looped-back postings which we regexp block at vger.  If vger responded
in some way it would just exacerbate any real list loop.

Warty didn't thing he could fix it easily, so we decided it was most easy
to just go straight to solely using stable@vger.kernel.org and just shut
down stable@kernel.org
