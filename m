Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1E2HnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:43:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46053 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1E2HnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kl0MxWXSISrCcStTp8lMBiWPK6mhj/Slwf8NMcCOBv+96jeauVc2aT4AWODhtpDbU4
         4CBI4PacGahr1dsaenJzEMUhbEo9CdMsGTYi9Bi4e7aamiW/lbZuJtPCXvCkMvEhR1iX
         wdDL+8hc2jMJ2hokd3B+93/Om76IET1D2Ft9c=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110529073840.GB21254@elte.hu>
References: <4DDECA9B.8080206@fb.com>
	 <1306447292.2543.32.camel@edumazet-laptop> <4DDEEBC5.80804@fb.com>
	 <1306466831.2543.58.camel@edumazet-laptop> <4DDFE4D6.4010000@fb.com>
	 <1306526219.2533.3.camel@edumazet-laptop>
	 <20110527211419.GA6793@dev1756.snc6.facebook.com>
	 <1306561285.2533.9.camel@edumazet-laptop> <20110528180434.GB12530@elte.hu>
	 <1306654424.30021.7.camel@edumazet-laptop> <20110529073840.GB21254@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 May 2011 09:43:03 +0200
Message-ID: <1306654983.30021.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 29 mai 2011 à 09:38 +0200, Ingo Molnar a écrit :

> Yes and i do this all the time as well, to make life easier for the 
> stable team.
> 
> What wasnt fine was to not follow up the backportable hack with the 
> proper patch though. Or did you plan to do that yourself if Arun 
> fails to complete the generic variant? (in which case my remark is 
> moot)
> 

I am currently working on seqlock.h split into seqcount.h and seqlock.h,
because I really need this split, but can take care of this work too, no
problem :

I asked Arun if he wanted to make this himself, because initial idea was
coming from him, not because I did not want to make it ;)



