Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0KEHQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:16:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0KEHQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G26H5rwlb1ugT5vANmnYgjPS+hZJztl5hhUNSynO16mtYsecHPZwHRH1zyEH92AaKf
         IOslvfoc3/D0luY1zlDx2W3H5ieoJC6+1TjdWTEPbhqpGK7stvCVLk52fGUljH6MSJcE
         gQ8HLSFsQsx8/UK9PQfh33Di5IX+ilo3AYrIY=
Subject: Re: [PATCH 46/49] net/netfilter: Use vzalloc
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Jiri Kosina <trivial@kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288940146.18440.55.camel@Joe-Laptop>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>
	 <1288938640.3234.12.camel@edumazet-laptop>
	 <1288940146.18440.55.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 08:16:11 +0100
Message-ID: <1288941371.3234.31.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 23:55 -0700, Joe Perches a écrit :
> On Fri, 2010-11-05 at 07:30 +0100, Eric Dumazet wrote:
> > I had _one_ patch, waiting that David actually had vzalloc() in its tree
> > before sending it.
> 
> Fine by me, use yours.

I dont care at all, only to say that David tree was not ready yet.


> 
> > Given Jesper Juhl was doing this work, could you please take another
> > one, please ?
> > For example, explaining him how to use other tools than "bash+egrep
> > +manual inspection" as he mentioned in a previous mail.
> 
> Jesper Juhl was both pointed at the cocci docs and
> given a cocci script.  He said he'd investigate it
> when he could.  I trust he will get to it.
> 

Yes, yet you posted patches, knowing he was working on the _same_
subject.

I remember other occurrences of such behavior.

I find this behavior very unfriendly, time consuming, and not useful.

We try to work together, to increase our common knowledge, not to throw
a bunch of patches "just because I know better than you"



