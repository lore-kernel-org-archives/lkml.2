Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1HXDhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:37:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34507 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1HXDhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:37:13 -0400
Message-ID: <4E5471C9.6030100@gmail.com>
Date: Tue, 23 Aug 2011 20:36:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
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


yeah.. I randomly guessed a kernel with git reset v2.6* to find a good 
point(could of even have been 2.6.37/8/9) will give a try and see if I 
get anywhere with this(I have 15 rev's to test, Ill see yeah in a few 
days!!).

Justin P. Mattock
