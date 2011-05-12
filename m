Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1ELVKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:10:35 -0400
Received: from outmail015.snc4.facebook.com ([66.220.144.147]:55324 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932699Ab1ELVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:10:34 -0400
Date: Thu, 12 May 2011 14:10:33 -0700
From: Arun Sharma <asharma@fb.com>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, StuStaNet Vorstand <vorstand@stusta.mhn.de>
Subject: Re: Kernel crash after using new Intel NIC (igb)
Message-ID: <20110512211033.GA3468@dev1756.snc6.facebook.com>
References: <201104250033.03401.maxi@daemonizer.de>
 <1303878240.2699.41.camel@edumazet-laptop>
 <1303878771.2699.44.camel@edumazet-laptop>
 <201104271352.00601.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104271352.00601.maxi@daemonizer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:51:59PM +0200, Maximilian Engelhardt wrote:
> 
> thank you for this information. I updated the kernel of the affected server to 
> version 2.6.38.4 yesterday. I'll report when there are still crashes, but it 
> might take a while, as in the past they only happened within the interval of 
> weeks to month.

I've seen this panic on 2.6.38.y as well. It's rare (< 1%), but the
panic consistently happens at the same place.

Are any of the inetpeer.c commits in the 2.6.39 tree, which are not in -stable yet,
good candidates to try?

 -Arun
