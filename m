Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1H0PDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:03:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51756 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1H0PDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 11:03:32 -0400
Message-ID: <4E59072A.5040108@gmail.com>
Date: Sat, 27 Aug 2011 08:03:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45
 [ttm]}
References: <4E506DEA.1070601@gmail.com> <20110821221602.GK25996@one.firstfloor.org> <4E53EB01.7080905@gmail.com> <987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 01:15 PM, Luck, Tony wrote:
>> its easily fixable, but not sure its a good idea due to bisect going
>> through commits(afraid I might go astray with the bisect if I add any
>> patches).
>
> Rather than fixing a bad build - you can try moving to a nearby commit
> (use "gitk" to get a view of the structure around the commit that git
> bisect suggested).  In the early stages of a bisection, it doesn't really
> matter much if you build the mid-point that bisect provided, or some
> nearby on - just be sure to mark good/bad the commit you actually built.
>
> -Tony
>
>

well.. after bisecting(with no results), I found that something in my 
.config was causing this, so after looking through, I found that having 
X86_MCE_INJECT = y causes the pauses when the timeouts occur

let me know if I need to supply any info.

Justin P. Mattock
