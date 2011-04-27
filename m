Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab1D0ME2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:04:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54357 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1D0ME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mj8P9p3EXGHM5n4S17haIHyl9chhdPlccp3FQIRiC+qfdwQdEynVYLL6iARr0yZ7Xq
         YZQYeH46lG//bLnrL8Ua6XW2OcA3Xotpwd1TlpEk6GNxLOQaNOV+IDWJUyh62uPJGfn8
         dCiI0vF4oHrIygz5NmBM4kPRk81I1EtAFWOgc=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
In-Reply-To: <201104271346.34431.maxi@daemonizer.de>
References: <201104250033.03401.maxi@daemonizer.de>
	 <EDC0E76513226749BFBC9C3FB031318F016B4125A4@orsmsx508.amr.corp.intel.com>
	 <201104271346.34431.maxi@daemonizer.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 14:04:18 +0200
Message-ID: <1303905858.3166.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 13:46 +0200, Maximilian Engelhardt a écrit :

> Hello Carolyn,
> 
> Thanks for your response.
> 
> I have opened a issue at
> https://sourceforge.net/tracker/?func=detail&aid=3293703&group_id=42302&atid=447449
> and also posted all information there.
> 
> 
> Please not that yesterday I updated the kernel, so I'm now running 2.6.38.4.
> Eric Dumazet mentioned on the LKML that this might be a memory corruption that 
> my be solved with kernel 2.6.38.
> 

Hmm, I suggested to use slub_nomerge to make sure inetpeer kmemcache is
not shared with another (possibly mem corruptor) layer.

Please note we were not able to track the bug in 2.6.37 kernels.

> I'll report if the crash happens again, but it might take some times as in the 
> past it happened within the interval of weeks to month.
> 

Thanks


