Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0DONLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:11:44 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:4502 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751032Ab0DONLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:11:43 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L0X5Z7-01-1NO-02
X-M-MSG: 
Date: Thu, 15 Apr 2010 15:11:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] perf, x86: setup NMI handler for IBS
Message-ID: <20100415131130.GK11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-11-git-send-email-robert.richter@amd.com>
 <1271336255.1674.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271336255.1674.8.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Apr 2010 13:11:30.0751 (UTC) FILETIME=[2A1584F0:01CADC9D]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.10 14:57:35, Peter Zijlstra wrote:
> > +/* uninitialize the APIC for the IBS interrupts if needed */
> > +static void clear_ibs_nmi(void)
> > +{
> > +	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
> > +}
> 
> 
> That on_each_cpu() looks wonky, why isn't this in the hotplug hooks?

Right, it should be there. Will update this patch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

