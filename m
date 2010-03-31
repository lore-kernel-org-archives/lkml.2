Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0CaNfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab0CaNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:35:45 -0400
Date: Wed, 31 Mar 2010 09:35:33 -0400
From: Neil Horman <nhorman@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, netdev@vger.kernel.org,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100331133533.GD13963@hmsreliant.think-freely.org>
References: <20100331102142.GA3294@swordfish.minsk.epam.com>
 <20100331111942.GB13963@hmsreliant.think-freely.org>
 <20100331121426.GB3294@swordfish.minsk.epam.com>
 <1270038569.2103.24.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270038569.2103.24.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:29:29PM +0200, Eric Dumazet wrote:
> Le mercredi 31 mars 2010 à 15:14 +0300, Sergey Senozhatsky a écrit :
> 
> 
> > PKT_SIZE="pkt_size 2048"
> > 
> 
> If you use 1024 bytes pktgen messages, do you still have the problem ?
> 
+1 I wouldn't be suprised if using something over the nominal 1522 byte frame
length on r8169 caused tx errors.  The driver doesn't seem to support Jumbo
frames, so my guess is you have to keep the packet size below 1522 bytes.
Neil

> 
