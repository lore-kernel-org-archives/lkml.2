Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2BWXb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:31:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57696 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2BWXb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:31:57 -0500
Date: Thu, 23 Feb 2012 18:31:45 -0500 (EST)
Message-Id: <20120223.183145.519627082998533863.davem@davemloft.net>
To: tj@kernel.org
Cc: mroos@linux.ee, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120223185503.GI22536@google.com>
References: <20120222174825.GA32694@google.com>
	<alpine.SOC.1.00.1202222025120.20496@math.ut.ee>
	<20120223185503.GI22536@google.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 23 Feb 2012 15:31:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 23 Feb 2012 10:55:03 -0800

> Hello,
> 
> On Wed, Feb 22, 2012 at 08:25:32PM +0200, Meelis Roos wrote:
>> > Can you please try the following patch?  If it still fails to boot,
>> > please attach the failing log.  Thank you.
>> 
>> It works on E3500! Will try other machines tomorrow.
> 
> Once confirmed, I'll push the patch through tip.  It just hides the
> underlying problem but we should be in no worse shape than before,
> it's two line change so reproduing the problem again for proper
> diagnosing isn't difficult, and we're getting a bit late in release
> cycle already.

Ok.
