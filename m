Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1EWAiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:38:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1EWAiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:38:17 -0400
Message-ID: <4DD9AC5A.4010606@zytor.com>
Date: Sun, 22 May 2011 17:37:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Tony Luck <tony.luck@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>	 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>	 <20110520131108.GA17699@elte.hu> <1306089922.1806.27.camel@dan>	 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com> <1306110336.25049.7.camel@dan>
In-Reply-To: <1306110336.25049.7.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 05:25 PM, Dan Rosenberg wrote:
> 
>> Sometime soon you'll have "rdrand" available (check a different cpuid
>> bit).
> 
> This of course is highly preferable, but I'd rather implement a solution
> that's widely supported in hardware today.  Perhaps further down the
> road it could be switched.
> 

Use the better one that is actually available.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

