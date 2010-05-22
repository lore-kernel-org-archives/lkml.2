Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0EVDh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:37:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38281 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0EVDh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:37:27 -0400
Message-ID: <4BF7507F.20805@zytor.com>
Date: Fri, 21 May 2010 20:33:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
In-Reply-To: <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2010 07:03 PM, john stultz wrote:
> 
> Yea, the relative instability of the tsc calibration at boot is an
> issue for folks who want very very precise timekeeping immediately
> after a reboot.
> 
> I proposed a solution to this awhile back via a boot option users
> could use to specify the tsc_khz freq, so it would be consistent from
> boot to boot. See: https://patchwork.kernel.org/patch/22492/
> 
> It didn't really go anywhere due to a lack of public interest.
> However, if you're interested in playing with it, I can try to revive
> the patch.
> 

The point about NTP is a very good one; with NTP you *really* want what
you're adjusting to be directly related to the crystal oscillator -- as
what it is; precision over accuracy as NTP takes care of accuracy but
not precision.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

