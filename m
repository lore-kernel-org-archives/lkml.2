Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1LWQuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:50:40 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52013 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1LWQuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:50:37 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz146fK1432N98dKzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWO1G8-02-8NX-02
X-M-MSG: 
Date: Fri, 23 Dec 2011 17:50:30 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223165030.GG16765@erda.amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111223163930.GA5983@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.11 17:39:30, Ingo Molnar wrote:
> No, i think you misunderstood me, i definitely think getting all 
> the data out is perfectly fine and useful, if the hardware 
> provides it. No need to make 'every' conceivable piece of IBS 
> data useful straight away.
> 
> All i want is at least *one* common usecase to work fine. This 
> allows us to see things in practice and it also provides the 
> seed for further improvements.
> 
> Right now this does not seem to be the case: the 'report' 
> portion only reports a raw hexa dump, not very useful to users.
> 
> Once something like 'perf report' works for some useful looking 
> sub-case you can also tack on all the extra IBS goodies that 
> specialized tools might need as well, i have no problem with 
> providing that.

Isn't that outlook I gave about pebs like implementation of the
precise bit with IBS "useful enough"? This would be on top patches
anyway, so no need to hold back current patches.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

