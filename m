Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0DWPi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:38:28 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:12436
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756759Ab0DWPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:38:26 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzz6ff19hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1C63R-01-D8H-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 17:38:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100423153810.GL6450@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100401011725.GA27567@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 15:38:11.0582 (UTC) FILETIME=[FB17C1E0:01CAE2FA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.04.10 03:17:25, Andi Kleen wrote:
> Got confirmation now this patch fixes most of the dropped oprofile
> samples problem on a particular intensive test on a large system.
> So now submitting the previous RFC formally.
> .34 / Stable candidate.

Patch applied to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks Andi and sorry for this late response.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

