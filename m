Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1AVVUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 16:20:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36988 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1AVVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 16:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uhjC4WDta99PJ7MgbA0dBKIyZN+cFM2EFttkMRwrngjUSQtqZl0DVOZA83GoMGoN+v
         YG5EBgAnwGxVRWJvWfMWtWy7KwLOo3jDitkrsAcPWwPYQBRMxN56RtPH7rwwwFTO6v7g
         gfPZJj7+2sqaYqrt3IVryTVdZ0gqlTXNJNDhE=
Subject: Re: Problems with /proc/net/tcp6  - possible bug - ipv6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: PK <runningdoglackey@yahoo.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <115440.16148.qm@web63902.mail.re1.yahoo.com>
References: <702550.61465.qm@web63902.mail.re1.yahoo.com>
	 <1295686781.2609.37.camel@edumazet-laptop>
	 <1295709344.2651.55.camel@edumazet-laptop>
	 <115440.16148.qm@web63902.mail.re1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 22:20:35 +0100
Message-ID: <1295731235.2651.66.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 22 janvier 2011 à 11:42 -0800, PK a écrit :
> Eric Dumazet wrote:
> > 
> > I had some incidents, after hours of testing...
> >
> > After following patch, I could not reproduce it.
> 
> 
> Looks like that patch solved the /proc/net/tcp6 problem.  The causal commit was 
> the one you identified... confirmed with bisect.
> 
> These warnings show up when I run the script (or I presume any tcp6 connection 
> flooder) with /proc/sys/net/tcp/ipv4/tcp_tw_recycle enabled.  There's textual 
> corruption of the traces a lot of the time.  Here's a sample trace that doesn't 
> appear to be corrupt.  All the warnings I've seen are from route.c:209, and I 
> don't see how that would cause memory corruption.

Thats a different isse, already reported, under investigation.

David did some changes recently

http://comments.gmane.org/gmane.linux.network/179874




