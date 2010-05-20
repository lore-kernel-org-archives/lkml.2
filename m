Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0ETQd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:33:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab0ETQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:33:28 -0400
Date: Thu, 20 May 2010 09:31:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
In-Reply-To: <20100519.193426.09743465.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.1005200929150.23538@i5.linux-foundation.org>
References: <20100518.233752.256882583.davem@davemloft.net> <20100519.193426.09743465.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, David Miller wrote:
> > 
> >   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master
> 
> Ping?

I'm still merging. I don't want to merge everything in one day, because I 
want to encourage people that do nightly snapshots or find problems 
quickly, and not force them to bisect through multiple thousand commits. 
So I tend to try to merge in chunks.

				Linus
