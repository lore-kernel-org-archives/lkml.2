Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0JEKcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:32:35 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41821
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932939Ab0JEKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:32:32 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L9TBWR-01-C8I-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 12:31:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/5] oprofile updates for v2.6.37
Message-ID: <20101005103139.GX13563@erda.amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.10.10 17:56:22, Robert Richter wrote:
> This patch set contains some rework and cleanups of the oprofile code.
> It also contains changes of the oprofile perf backend that is
> currently implemented for the ARM architecture, but will be ported to
> oprofile generic code.
> 
> Will, please ack the ARM changes if you are fine with it.

Will, thanks for your review.

I have applied the patches to oprofile/core.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

