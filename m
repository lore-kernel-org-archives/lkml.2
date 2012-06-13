Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2FMNme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:42:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52769 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab2FMNmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:42:33 -0400
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com> <20120612190720.GA11137@aftab.osrc.amd.com> <1339529614.31548.104.camel@twins> <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com> <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com> <1339591173.8980.23.camel@twins>
User-Agent: K-9 Mail for Android
In-Reply-To: <1339591173.8980.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 13 Jun 2012 06:22:22 -0700
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Message-ID: <6a059272-2514-4dd9-a616-8eef69d1511b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't remember the exact details of the old interface but yes... seems like every "improvement" has just made it a worse mess.

Peter Zijlstra <peterz@infradead.org> wrote:

>On Tue, 2012-06-12 at 13:42 -0700, H. Peter Anvin wrote:
>> And yes, I would prefer a single sysfs file,
>> or better yet a plain old device node. 
>
>So how about we rip out all this sysfs crap and go back to
>MICROCODE_OLD_INTERFACE ? Afaict that's relatively sane.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
