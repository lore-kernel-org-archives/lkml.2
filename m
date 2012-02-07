Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2BGBsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:48:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2BGBsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:48:03 -0500
Message-ID: <4F308243.8030003@zytor.com>
Date: Mon, 06 Feb 2012 17:45:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
References: <1328560933-3037-1-git-send-email-venki@google.com> <4F306FAF.7020500@cavium.com> <4F307D45.1050404@zytor.com> <4F307FB3.4030700@gmail.com>
In-Reply-To: <4F307FB3.4030700@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 05:34 PM, David Daney wrote:
>
> Well I don't know that part. The gist of my comment was to get rid of an
> unneeded new config variable.
>
> If this works just as well for 32-bit, then by all means do it there too.
>
> In any event, I think you want the kernel to automatically do it if the
> CPU is capable, and not have a manual config setting you have to fiddle
> with.
>

If this is a transitional thing then it might justify it.

	-hpa

