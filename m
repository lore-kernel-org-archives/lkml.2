Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2FMOBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:01:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab2FMOBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:01:08 -0400
Message-ID: <4FD89D09.6010800@zytor.com>
Date: Wed, 13 Jun 2012 07:00:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>  <20120612190720.GA11137@aftab.osrc.amd.com>  <1339529614.31548.104.camel@twins>  <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com>  <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com>  <20120612205609.GF11137@aftab.osrc.amd.com> <4FD7AD6F.6010008@zytor.com> <1339576681.31548.116.camel@twins>
In-Reply-To: <1339576681.31548.116.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 01:38 AM, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 13:58 -0700, H. Peter Anvin wrote:
>>  even things like Nehalem + Westmere in the same system
> 
> Uhm,.. how well do you expect Linux to run on a franken-system like
> that? I'm pretty sure perf will malfunction in such a setup.
> 

perf might, but I have seen such frankensystems in the field and they
work (although I haven't seen that particular combo, I have to admit.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

