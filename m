Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab0DATC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:02:27 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:30595
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755486Ab0DATCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:02:23 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz98dN936eM62a3L1315kzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L07OVI-02-EHE-02
X-M-MSG: 
Date: Thu, 1 Apr 2010 21:02:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100401190205.GD6027@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100401011725.GA27567@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Apr 2010 19:02:06.0299 (UTC) FILETIME=[D276EAB0:01CAD1CD]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.04.10 03:17:25, Andi Kleen wrote:
> Got confirmation now this patch fixes most of the dropped oprofile
> samples problem on a particular intensive test on a large system.
> So now submitting the previous RFC formally.
> .34 / Stable candidate.

Thanks Andi, will take a look at this next week.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

