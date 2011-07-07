Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1GGJji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:39:38 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37234
	"EHLO CH1EHSOBE011.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752104Ab1GGJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:39:36 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYITT-02-AXY-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 11:39:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110707093926.GJ4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
 <20110706165357.GG4590@erda.amd.com>
 <1309972368.3282.317.camel@twins>
 <20110707092102.GI4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110707092102.GI4590@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more note:

> On 06.07.11 13:12:48, Peter Zijlstra wrote:

> > perf stat -e IBS:fetches will always have a fail against rmmod, rmmod
> > could complete before we try to open the file (assuming IBS is a
> > module).

If the module is busy, it wont be unloaded.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

