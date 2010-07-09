Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0GIRwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:52:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48279
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab0GIRwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:52:39 -0400
Date: Fri, 09 Jul 2010 10:52:53 -0700 (PDT)
Message-Id: <20100709.105253.71108558.davem@davemloft.net>
To: rpartearroyo@albentia.com
Cc: eric.dumazet@gmail.com, herbert@gondor.hengli.com.au,
       linux-kernel@vger.kernel.org, ipichel@albentia.com, nmoron@albentia.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 001/001] QoS and/or fair queueing: Stateless NAT BUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <201007091937.17349.rpartearroyo@albentia.com>
References: <201007091937.17349.rpartearroyo@albentia.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodrigo Partearroyo González <rpartearroyo@albentia.com>
Date: Fri, 9 Jul 2010 19:37:16 +0200

> Hi all,
> I have been testing Stateless NAT and found that ICMP packets with length
> less than 20 bytes were not correctly NAT'ed. I have found a BUG that
> makes taking into account IP header length twice, so ICMP packets smaller
> than 20 bytes were being dropped.
> 
> Proposed formal patch is below, as suggested by Eric Dumazet, thanks.
> It is taken from 2.6.34.1 stable version.
> 
> Signed-off-by: Rodrigo Partearroyo González <rpartearroyo@albentia.com>

Applied, thanks.
