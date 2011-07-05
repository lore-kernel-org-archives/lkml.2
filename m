Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1GEK4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:56:14 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:45890
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394Ab1GEK4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:56:13 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1447R1432N98dKzz1202hzz8275eh3284qa1495iz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNUX1J-01-T3F-02
X-M-MSG: 
Date: Tue, 5 Jul 2011 12:56:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Extend attr check to allow also dynamically
 generated
Message-ID: <20110705105605.GD4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <20110705094714.GA4590@erda.amd.com>
 <1309863060.3282.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309863060.3282.52.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.07.11 06:51:00, Peter Zijlstra wrote:
> Lin Ming submitted a similar patch:
> 
>  http://marc.info/?l=linux-kernel&m=130942109729864
> 
> Which I prefer as it removes code. Event creation will fail in
> perf_init_event() in that case when an invalid type is specified.

Thanks for the pointer, ignore my resent patch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

