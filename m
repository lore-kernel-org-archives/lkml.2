Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0JEKnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:43:17 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:35361 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab0JEKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:43:16 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i2a8h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L9TCE6-01-CLB-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 12:42:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        William Cohen <wcohen@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] oprofile: disable write access to oprofilefs while
 profiler is running
Message-ID: <20101005104207.GY13563@erda.amd.com>
References: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.10.10 06:36:57, Robert Richter wrote:
> Oprofile counters are setup when profiling is disabled. Thus, writing
> to oprofilefs has no immediate effect. Changes are updated only after
> oprofile is reenabled.
> 
> To keep userland and kernel states synchronized, we now allow
> configuration of oprofile only if profiling is disabled.  In this case
> it checks if the profiler is running and then disables write access to
> oprofilefs by returning -EBUSY. The change should be backward
> compatible with current oprofile userland daemon.
> 
> Cc: Maynard Johnson <maynardj@us.ibm.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Maynard, please ack if you are fine with it.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

