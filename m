Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0GNWgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:36:37 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:42135 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756735Ab0GNWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:36:36 -0400
Date: Thu, 15 Jul 2010 00:36:33 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Ed W <lists@wildgooses.com>
Cc: Rick Jones <rick.jones2@hp.com>, David Miller <davem@davemloft.net>,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100714223633.GJ6682@nuttenaction>
References: <4C3D94E3.9080103@wildgooses.com>
 <4C3DD5EB.9070908@tmr.com>
 <20100714.111553.104052157.davem@davemloft.net>
 <4C3E0684.5060409@wildgooses.com>
 <4C3E1B54.40604@hp.com>
 <20100714203919.GD6682@nuttenaction>
 <4C3E34AB.2060405@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E34AB.2060405@wildgooses.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ed W | 2010-07-14 23:05:31 [+0100]:

>Initial cwnd was changed (increased) in the past (rfc3390) and the
>RFC claims that studies then suggested that the benefits were all
>positive. Some reasonably smart people have suggested that it might
>be time to review the status quo again so it doesn't seem completely
>obvious that the current number is optimal?

Do you cite "An Argument for Increasing TCP's Initial Congestion Window"?
People at google stated that a CWND of 10 seems to be fair in their
measurements. 10 because the test setup was equipped with a reasonable large
link capacity? Do they analyse their modification in environments with a small
BDP (e.g. multihop MANET setup, ...)? I am curious, but We will see what
happens if TCPM adopts this.

>That RFC is a subtle read - it appears to give more specific guidance
>on what to do in certain situations, but I'm not sure I see that it
>improves slow start convergence speed for my situation (large RTT)?
>Would you mind highlighting the new bits for those of us a bit newer
>to the subject?

The objection/hint was more of general nature - not specific for larger RTTs.
Environments with larger RTTs are disadvantaged because TCP is ACK clocked.
Half-truth statement for my part because RTT fairness is and was an issue at
the development of new congestion control algorithms: BIC, CUBIC and friends.

>>Partial local issues can already be "fixed" via route specific ip options -
>>see initcwnd.
>
>Oh, excellent.  This seems like exactly what I'm after.  (Thanks
>Stephen Hemminger!)

Great, you are welcome! ;-)


Hagen


