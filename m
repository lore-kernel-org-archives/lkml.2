Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2GQB4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:56:20 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40103 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQB4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:56:18 -0400
Message-ID: <5004C604.8040308@us.ibm.com>
Date: Mon, 16 Jul 2012 18:55:16 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression][Revert request] Excessive delay or hang during resume
 from system suspend due to a hrti
References: <CA+icZUXURRAs-rK1EnRidYUQ9NXXYw4DaHbn=4mcEe3Q0sU+2A@mail.gmail.com> <CA+icZUWUhZpRKU5rO+m4Xe1DNLYAq8NPBCS_B2c3Kmgq+gBQ3w@mail.gmail.com> <5004553A.2060104@us.ibm.com>
In-Reply-To: <5004553A.2060104@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071701-5518-0000-0000-0000061620EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 10:54 AM, John Stultz wrote:
>
> Thanks for sending your config and test results.
>
> Looking at the call trace you provided, I'm not seeing anything yet, 
> but I'll be looking over the code while running my test boxes in a 
> reboot loop w/ your config to see if I can't figure out the 
> get_next_timer_interrupt issue you saw at bootup.

Left my two boxes (one bare-metal, the other a VM) in reboot loops all 
day with your config and haven't hit anything. :(

Do let me know if you're able to trigger this again. Given that the back 
trace you listed doesn't seem to be directly linked to the leapsecond 
related hrtimer changes, I'm wondering if this might be something else.

But if you get any more details, do let me know and I'll try to sort it out.

thanks
-john

