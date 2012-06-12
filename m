Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2FLU1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:27:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45492 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2FLU1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:27:45 -0400
Message-ID: <4FD7A624.3050800@zytor.com>
Date: Tue, 12 Jun 2012 13:27:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>  <20120612190720.GA11137@aftab.osrc.amd.com> <1339529614.31548.104.camel@twins>
In-Reply-To: <1339529614.31548.104.camel@twins>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 12:33 PM, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 21:07 +0200, Borislav Petkov wrote:
>> Nice, this is the initrd cpio thing, cool, no changes needed for the
>> bootloader. Ping me when you have something ready so that I can start
>> testing it here too. 
> 
> What do people like me do that don't use initrd like nonsense?
> 

There is no requirement that you use an initramfs userspace.  This is
just data loaded via the initramfs protocol rather than inventing a new one.

	-hpa


