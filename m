Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1LRP3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 10:29:08 -0500
Received: from server102.greatnet.de ([83.133.97.2]:45066 "EHLO
	server102.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LRP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 10:29:07 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Dec 2011 10:29:06 EST
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
MIME-Version: 1.0
Date: Sun, 18 Dec 2011 16:22:13 +0100
From: Benjamin Block <bebl@mageta.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Block <benjamin.block@amd.com>
Reply-To: bebl@mageta.org
In-Reply-To: <20111218080443.GB4144@elte.hu>
References: <20111216160757.GL665@escobedo.osrc.amd.com> <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu>
Message-ID: <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
User-Agent: RoundCube Webmail/0.3-stable
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 18 Dec 2011 09:04:43 +0100, Ingo Molnar <mingo@elte.hu> wrote:

> * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> 

>> From: Benjamin Block <benjamin.block@amd.com>

>> 

>> Implements a basic integration of LWP into perf. Permits a way 

>> to create a perf-event that will be backed by LWP. The PMU 

>> creates the required structures and userspace-memories. The 

>> PMU also collects the samples from the ring-buffer, but as 

>> there is currently no interrupt- and overflow-implementation, 

>> they are not reported (TODO).

> 

> Ok, this is a step in the right direction - once the threshold 

> IRQ flow control mechanism is implemented we are looking at 

> something that might be mergeable. Any ETA on those bits?

> 



The threshold-interrupt is already integrated with patch 5 of this 

patch-set.



Maybe I wrote the descriptions a little misleading. Sry for that. :)



best regards,

- Benjamin
