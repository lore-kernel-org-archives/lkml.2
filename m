Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2H1RuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:50:05 -0400
Received: from plane.gmane.org ([80.91.229.3]:52532 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2H1RuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:50:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rune Darrud <theflyingcorpse@gmail.com>
Subject: Re: gateway icmp redirect handling problem (3.0.36-3.0.23)
Date: Tue, 28 Aug 2012 17:35:14 +0000 (UTC)
Message-ID: <loom.20120828T192412-953@post.gmane.org>
References: <e7c3421bfc919c64cc6268c575429640@segfault.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 195.134.41.194 (Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20100101 Firefox/13.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See inline answer below.

Simon Roscic <simon <at> segfault.info> writes:

> 
> i did some further tests with different kernel versions:
> 3.5-rc6: OK
> 3.4.4: OK
> 3.2.22: OK
> 3.0.1 - 3.0.22: OK
> 3.0.23 - 3.0.36: not OK
> 2.6.35.13: OK

Let me add that kernel 3.0.38 also experiences the same for SLES 11 SP2. A
restart of the network resolves it temporarily for a few hours. After running
fine for a few hours after upgrade from 2.6.3x to 3.0.38 via zypper, this is not
a good situation.

> 
> now lets have a closer look at a kernel version which works:
> .....
> 
> (before someone asks why i "must" use kernel 3.0.x ... because this are 
> SLES 11 SP2 VMs and they currently ship kernel 3.0.34)

Going to raise an SR with Novell about this.

> 
> i hope i described the problem in a way so that the kernel network 
> stack maintainers can understand the problem, please conact me if you 
> have further questions, and please CC me as i am not subscribed to 
> linux-kernel. this message is already on linux-netdev, if you wish you 
> can CC your answer also there.
> 
> kind regards,
> Simon Roscic.
> 
> 

Best regards,
Rune "TheFlyingCorpse" Darrud



