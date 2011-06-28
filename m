Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1F1OVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:21:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:16234 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1F1OTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:19:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="19747546"
Message-ID: <4E09E300.2060800@linux.intel.com>
Date: Tue, 28 Jun 2011 07:19:44 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Shawn Bohrer <sbohrer@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH v2] futex: Fix regression with read only mappings
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>	 <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com>	 <4E052DC3.6000902@linux.intel.com>	 <20110627164008.GA2095@BohrerMBP.rgmadvisors.com>	 <1309198559.6701.108.camel@twins> <4E08EAE8.6060805@linux.intel.com>	 <20110627210818.GC2095@BohrerMBP.rgmadvisors.com>	 <4E08F893.10103@linux.intel.com> <1309258236.6701.199.camel@twins>
In-Reply-To: <1309258236.6701.199.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2011 03:50 AM, Peter Zijlstra wrote:
> On Mon, 2011-06-27 at 14:39 -0700, Darren Hart wrote:
>> The alternative it seems is to just let RW private users hang
>> themselves.
> 
> Yeah, screw those, that's insane anyway.

And I meant RO private users (for those reading just this message and
getting really confused ;-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
