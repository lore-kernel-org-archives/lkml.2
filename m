Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab1LFJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:29:16 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:20102
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932901Ab1LFJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:29:14 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVRZOK-02-C1Y-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 10:29:05 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "acme@redhat.com" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111206092905.GJ15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
 <20111129182231.GZ15738@erda.amd.com>
 <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
 <20111130150829.GA15738@erda.amd.com>
 <20111130164946.GA27163@infradead.org>
 <20111201150151.GA15110@somewhere.redhat.com>
 <20111201151520.GB15738@erda.amd.com>
 <CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
 <20111205132340.GH15738@erda.amd.com>
 <CABPqkBTBpMao99t407Oz1cKMAVDYEsFSLUe85DYeOzxzuhZ9hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBTBpMao99t407Oz1cKMAVDYEsFSLUe85DYeOzxzuhZ9hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.11 11:24:05, Stephane Eranian wrote:
> The one thing I realized last week, is that all that header information, incl.
> the features bits do not seem to appear in the file perf.data file when you
> use the perf record pipe mode. We need to fix that otherwise, if you
> depend on information in those bits, it won't always be present. That's
> a major issue.

Yes, this is because pipes are not seakable, which is necessary to
write the features.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

