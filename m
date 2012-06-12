Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2FLU3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:29:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2FLU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:29:20 -0400
Message-ID: <4FD7A687.3040500@zytor.com>
Date: Tue, 12 Jun 2012 13:28:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com> <20120612190720.GA11137@aftab.osrc.amd.com> <1339529614.31548.104.camel@twins> <20120612194900.GC11137@aftab.osrc.amd.com>
In-Reply-To: <20120612194900.GC11137@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 12:49 PM, Borislav Petkov wrote:
> 
> Also, I'd assume we need some of the current functionality to be able to
> load ucode without rebooting the box.
> 

Yes, the basic idea is that we'll keep the ucode around anyway so we can
feed it to hotplug CPUs or S3 resume.  If the ucode is updated from
userspace we'd replace the in-memory copy and load it into the CPUs.

	-hpa


