Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1AFMA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:00:26 -0500
Received: from copper.chdir.org ([88.191.97.87]:51384 "EHLO copper.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1AFMAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:00:25 -0500
From: Nicolas Bareil <nico@chdir.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: cl@linux.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] INFO: rcu_sched_state detected stall on CPU
References: <87mxne6z4o.fsf@puppet.chdir.org>
	<20110106114533.GH29257@csn.ul.ie>
X-Hashcash: 1:20:110106:torvalds@linux-foundation.org::JcxCPigyOHsF1CYy:000000000000000000000000000000000ONk
X-Hashcash: 1:20:110106:linux-kernel@vger.kernel.org::7NTzsBbOZ17tEPsO:0000000000000000000000000000000000FkC
X-Hashcash: 1:20:110106:mel@csn.ul.ie::zqSPrlaw6Eho6kHi:000038SC
X-Hashcash: 1:20:110106:cl@linux.com::8CHJNbwvqzfaJVkE:000004tTS
X-Hashcash: 1:20:110106:akpm@linux-foundation.org::tvTX6kyj+UJGFfTJ:00000000000000000000000000000000000072mH
Date: Thu, 06 Jan 2011 13:00:23 +0100
In-Reply-To: <20110106114533.GH29257@csn.ul.ie> (Mel Gorman's message of "Thu,
	6 Jan 2011 11:45:34 +0000")
Message-ID: <87ei8q6y3s.fsf@puppet.chdir.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mel Gorman <mel@csn.ul.ie> writes:
> There should be a fix for this in Andrew's mm tree. At the moment, I'm
> expecting it to be merged for 2.6.38-rc1 but I'm also expecting it will be
> merged to the stable series as you are not the only person to encounter this
> sort of problem. To be sure, can you confirm if the following patch helps you?
> It's a copy of what is in Andrew's tree. Thanks

Indeed, this commit fixed the issue!

Thanks for your fast reply!
