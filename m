Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0ECFoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:44:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54782 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0ECFoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JbJZacETNeUBJRWz50WN+tzmK/+OQvGH91422iwbxw2yy47zh2BXlP9C5vaCs0samD
         RlCwS9k3Ls3+s3k1wuDVMFVV6Xjvzo0BcwIElQnH3orxOaX4HeQ2lDk6E8reEw681h1N
         91sjZxRieoJ25Lffve6w4M8xFQwohq6LaOR/c=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1272865267.2173.180.camel@edumazet-laptop>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <5702.1272822394@localhost>  <1272865137.2173.179.camel@edumazet-laptop>
	 <1272865267.2173.180.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 07:43:56 +0200
Message-ID: <1272865436.2173.182.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 07:41 +0200, Eric Dumazet a écrit :

> Oops scratch that, I'll resend a correct version.
> 
> 

Sorry, patch _is_ fine, I had one brain collapse when re-reading it, I
thought a different mutex was in use in one of the functions.


