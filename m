Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0DUIrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:47:19 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39888 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0DUIrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:47:17 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L17XQC-01-4YI-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 10:47:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100421084700.GU11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
 <20100420160557.GT11907@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100420160557.GT11907@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 08:47:01.0477 (UTC) FILETIME=[35BCF950:01CAE12F]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.04.10 18:05:57, Robert Richter wrote:
> > What is the problem with directly using the period here, rejecting
> > any value that is off range or with bottom 4 bits set?
> 
> Yes, I will create an updated version of this patch.

Stephane, do you think having the lower 4 bits set is worth an EINVAL?
I would rather ignore them since the accuracy is not really necessary
compared to a range lets say from 100000 cycles? Otherwise this will
make the setup of ibs much more complicated. The check could be moved
to userland and generate a waring or so.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

