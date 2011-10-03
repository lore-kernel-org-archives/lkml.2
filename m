Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab1JCQQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:16:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56217 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JCQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:16:17 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
In-Reply-To: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 18:16:28 +0200
Message-ID: <1317658588.2442.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 octobre 2011 à 11:25 -0400, starlight@binnacle.cx a écrit :

> >Please send full "dmesg" output 
> 
> Attached.
> 

Minor note :

It seems you use 4096 2MB hugepages, and your machine has 1GB pages
availabe, you could try to use them.

(boot cmd : hugepagesz=1GB hugepages=8 )



