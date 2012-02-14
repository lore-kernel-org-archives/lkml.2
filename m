Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2BNKu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 05:50:26 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:3727 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753566Ab2BNKuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 05:50:25 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4R8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZDQ3U-02-31U-02
X-M-MSG: 
Date: Tue, 14 Feb 2012 11:50:18 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>, <arnaldo.melo@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20120214105018.GV22598@amd.com>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
 <4F39CBE0.6050806@gmail.com>
 <4F39D00D.2060206@gmail.com>
 <4F39ECDB.5090609@lge.com>
 <4F39EFBB.2010301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F39EFBB.2010301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 10:23:07PM -0700, David Ahern wrote:
> On 2/13/12 10:10 PM, Namhyung Kim wrote:
> >>
> >
> >It happened because I used old kernel version that isn't aware of the
> >exclude_guest bit. So the check on attr->__reserved_1 in
> >core.c::perf_copy_attr() failed and then ended up seeing EINVAL at
> >perf_evsel__open().
> 
> comes back to 1aed2671738785e8f5aea663a6fda91aa7ef59b5 again. See
> 
> https://lkml.org/lkml/2012/2/8/234

Grr. I totally forgot that issue. Is there some way to detect the perf
kernel-features? Otherwise the only fix seems to be to drop the patch
changing the default. The crashes should be fixed by the other patch
already.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

