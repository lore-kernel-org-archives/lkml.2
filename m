Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0DSNoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:44:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25944
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751558Ab0DSNoD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:44:03 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432P1418Mzz1202hz31izz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L14M4Y-01-FK3-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "'joss@debian.org'" <joss@debian.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Apr 2010 06:43:48 -0700
Subject: Athlon L110 CPU and powernow-k8
Thread-Topic: Athlon L110 CPU and powernow-k8
Thread-Index: Acre/G7tcZX5bOQjTye14yU3Lj886wAx9EHw
Message-ID: <DDE95BDD51FB774B804A9C029E735EE103E9BF5129@sausexmbp02.amd.com>
References: <20100418102608.GA29846@a1.tnic>
In-Reply-To: <20100418102608.GA29846@a1.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Fri, 16 Apr 2010 22:40:58 +0200
> From: Josselin Mouette <joss@debian.org>
> To: linux-kernel@vger.kernel.org
> Subject: Athlon L110 CPU and powernow-k8
> X-Mailer: Evolution 2.29.92.1
> Message-ID: <1271450458.6794.33.camel@tomoyo>
> 
> In both cases, the issue is the same: the DSDT table provided by the
> BIOS does not include the P-states. Waiting for a hypothetical BIOS
> update that would fix this bug requires some faith that I 
> don't have. It is possible to work around this by compiling the
> kernel with a custom DSDT table with appropriate P-states patched
> in, however I consider this a developer hack. 
>
> I wonder what is possible to do to support this CPU correctly in the
> kernel. The only sane solution I can think of is to hardcode the
> P-states for this CPU model in the powernow-k8 driver itself. 

I think that hard-coding P-states into the PowerNow 
driver is not a mantainable solution.

I don't quite understand why the you think that
a custom DSDT as a BIOS hack, but think that
adding custom frequencies to the driver itself is
acceptable.

The last time this issue came up on cpufreq, Dave
Jones nixed a general solution to add custom P-states
through the driver on the grounds that people would
undervolt their systems, causing a lot of screwy,
unpredictable behavior.  I agreed with his opinion
then and I don't see anything in this mesage to
change that view.


--Mark Langsdorf
Operating System Research Center
AMD

