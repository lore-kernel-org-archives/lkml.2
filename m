Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2AQJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:48:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35787 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab2AQJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:48:10 -0500
Date: Tue, 17 Jan 2012 10:47:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 0/6] x86, UV2: BAU fixes for UV version 2
Message-ID: <20120117094749.GE10397@elte.hu>
References: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116211617.GD5512@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> Following are 6 patches for using SGI's Altix UV2's Broadcast 
> Assist Unit for TLB shootdown.
> 
> The first 3 patches are very necessary to using the BAU on 
> this new hardware.  Number 3 is a large one.

Note that when patches are fixing hardware support it's better 
to name them accordingly. I changed all the commit titles to 
reflect this fact.

I also added a Cc: stable backporting tag to the first three 
commits, they only affect UV code and it's useful to have a 
uniform hw platform driver across the stable kernels.

Thanks,

	Ingo
