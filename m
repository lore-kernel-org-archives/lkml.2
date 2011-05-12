Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1ELVQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:16:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59671 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab1ELVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bs3a+JLtHkS7jcBbqR7M7uDxcu4ma0gj7pINPkM2CUX28jXDMyrq6L9K95PNrhtV2h
         M+zzFotRNK/NJK+6375CBUYc+r8mgFCTgkdAlqXvp1IF+jB2a+K3TFjZSl+KR6hBuJlZ
         lRXT5YALGVJVzKwrUITp131p4x63ZGIMuU/TM=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <20110512211033.GA3468@dev1756.snc6.facebook.com>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
	 <1303878771.2699.44.camel@edumazet-laptop>
	 <201104271352.00601.maxi@daemonizer.de>
	 <20110512211033.GA3468@dev1756.snc6.facebook.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 23:15:53 +0200
Message-ID: <1305234953.2831.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 mai 2011 à 14:10 -0700, Arun Sharma a écrit :
> On Wed, Apr 27, 2011 at 01:51:59PM +0200, Maximilian Engelhardt wrote:
> > 
> > thank you for this information. I updated the kernel of the affected server to 
> > version 2.6.38.4 yesterday. I'll report when there are still crashes, but it 
> > might take a while, as in the past they only happened within the interval of 
> > weeks to month.
> 
> I've seen this panic on 2.6.38.y as well. It's rare (< 1%), but the
> panic consistently happens at the same place.
> 
> Are any of the inetpeer.c commits in the 2.6.39 tree, which are not in -stable yet,
> good candidates to try?
> 

Probably not.

What gives slub_nomerge=1   for you ?




