Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0DALYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:24:23 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44785 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab0DALX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:23:58 -0400
Message-ID: <4BB4823F.7040408@s5r6.in-berlin.de>
Date: Thu, 01 Apr 2010 13:23:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: w@1wt.eu, gregkh@suse.de, david@fromorbit.com,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] 4 stable kernel review cycles starting
References: <20100331215332.GH7671@dastard>	<20100331224755.GA23284@suse.de>	<20100401044048.GD16238@1wt.eu> <20100401.002622.179174704.davem@davemloft.net>
In-Reply-To: <20100401.002622.179174704.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Willy Tarreau <w@1wt.eu>
> Date: Thu, 1 Apr 2010 06:40:48 +0200
> 
>> For this reason, IMHO it helps when submitters can indicate in each
>> patch the mainline equivalent ID, or alternatively that it's pointless
>> to look for it because the fix is much different.
> 
> I put this at the top of every networking/ide/sparc commit message
> for -stable submissions I make.
> 
> In fact I thought that was a requirement for -stable submissions?

It is a documented requirement, perhaps not very clearly worded in The
Submitter's Guide To Stable...
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=46cdf871d9970b9252469531f9efd4a17243bb0b
-- 
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/
