Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1LEVZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:25:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:36720 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab1LEVZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:25:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Laurence Oberman <laurence.oberman@hp.com>
Subject: Re: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations
Date: Mon, 5 Dec 2011 21:15:21 +0000 (UTC)
Message-ID: <loom.20111205T221311-142@post.gmane.org>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>  <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>  <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>  <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>  <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>  <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E2A848@GVW1119EXC.americas.hpqcorp.net> <1318879445.2571.20.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 15.219.153.75 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric Dumazet <eric.dumazet <at> gmail.com> writes:


Hi Eric,

I finally managed to get some time to test the patch. I am testing on the
generic kernel.org 2.6.39 tree and will update you as soon as possible.

Thanks
Laurence




