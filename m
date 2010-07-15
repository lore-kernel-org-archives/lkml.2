Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab0GOMIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:08:17 -0400
Received: from mail-i4.nets.RWTH-Aachen.DE ([137.226.12.21]:55290 "EHLO
	MAIL-i4.nets.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582Ab0GOMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:08:16 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 08:08:16 EDT
Message-ID: <4C3EF7EA.2040900@nets.rwth-aachen.de>
Date: Thu, 15 Jul 2010 13:58:34 +0200
From: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
References: <4C358AAA.9080400@kernel.org> <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing new reordering algorithms in a virtual testbed, that is the 
nodes are emulated with xen and all the network parameters can be tuned 
with queues.
With one of the algorithms I also got tracebacks which include 
tcp_xmit_retransmit_queue. It only happens with ACK loss. The kernel 
version however is 2.6.31.
When I read this thread I tried the debug patch and got the following:

[ 2754.413150] NULL head, pkts 0
[ 2754.413156] Errors caught so far 1

Hope that is of any help.
