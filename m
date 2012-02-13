Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2BMB1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 20:27:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54372 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2BMB1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 20:27:19 -0500
Message-ID: <4F3866D4.9060209@zytor.com>
Date: Sun, 12 Feb 2012 17:26:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Ben Hutchings <ben@decadent.org.uk>, gregkh@linuxfoundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
References: <1329000256.325.48.camel@deadeye> <201202130010.57492.trenn@suse.de>
In-Reply-To: <201202130010.57492.trenn@suse.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 03:10 PM, Thomas Renninger wrote:
> On Saturday 11 February 2012 23:44:16 Ben Hutchings wrote:
>> This series fixes a number of apparent bugs in the recent changes to
>> enable auto-loading by x86 CPU ID.
> 
> These all look correct.
> I should have spotted the intel_idle modifications myself.
> Good catch(es).
> 
> Greg: I expect these should get queued in your driver-core-next branch?
> 

Either that or we can carry them in -tip as x86 patches, since there
isn't a pending conflict this time.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

