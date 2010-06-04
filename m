Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0FDOZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:25:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62733 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0FDOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HruoRZYdSnVDHWdvliugX5kCX1e19C8BDB4QPBTn0he8kzO5pWLq2v6o8kAz2yCGzg
         IB6EUmbpLOISp+GhBO2GJLO3nLR2GCxw5xHbBFhWFpj0VvzJa/6XQ0Kkm6rqit5jz7hG
         fjzAmR171mn8FgtiitAtkrkgSeYshb5kL5Xzo=
Subject: Re: [patch 2/4] lglock: introduce special lglock and brlock spin
 locks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20100604141318.GC26335@laptop>
References: <20100604064307.737085373@suse.de>
	 <20100604072618.400686656@suse.de>
	 <1275638163.2482.2.camel@edumazet-laptop>  <20100604141318.GC26335@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 16:24:25 +0200
Message-ID: <1275661465.2482.174.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 05 juin 2010 à 00:13 +1000, Nick Piggin a écrit :
> On Fri, Jun 04, 2010 at 09:56:03AM +0200, Eric Dumazet wrote:

> > IMHO some changes in Documentation/ would be needed
> 
> I wonder where, and what?
> 
>  

Documentation/memory-barriers.txt (around line 1111)

Documentation/spinlocks.txt  (change its name ?)

Section 1 : spinlocks

Section 2 : rwlocks

Section 3 : lglock/brlock  ?


