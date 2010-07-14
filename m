Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0GNWNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:13:07 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:42305 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757866Ab0GNWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:13:05 -0400
Date: Thu, 15 Jul 2010 00:13:01 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: David Miller <davem@davemloft.net>
Cc: rick.jones2@hp.com, lists@wildgooses.com, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100714221301.GI6682@nuttenaction>
References: <4C3E0684.5060409@wildgooses.com>
 <4C3E1B54.40604@hp.com>
 <20100714203919.GD6682@nuttenaction>
 <20100714.145547.102555471.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714.145547.102555471.davem@davemloft.net>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller | 2010-07-14 14:55:47 [-0700]:

>Although section 3 of RFC 5681 is a great text, it does not say at all
>that increasing the initial CWND would lead to fairness issues.

Because it is only one side of the medal, probing conservative the available
link capacity in conjunction with n simultaneous probing TCP/SCTP/DCCP
instances is another.

>To be honest, I think google's proposal holds a lot of weight.  If
>over time link sizes and speeds are increasing (they are) then nudging
>the initial CWND every so often is a legitimate proposal.  Were
>someone to claim that utilization is lower than it could be because of
>the currenttly specified initial CWND, I would have no problem
>believing them.
>
>And I'm happy to make Linux use an increased value once it has
>traction in the standardization community.

Currently I know no working link capacity probing approach, without active
network feedback, to conservatively probing the available link capacity with a
high CWND. I am curious about any future trends.

>But for all we know this side discussion about initial CWND settings
>could have nothing to do with the issue being reported at the start of
>this thread. :-)

;-) sure, but it is often wise to thwart these kind of discussions. It seems
these CWND discussions turn up once every other month. ;-)

Hagen

