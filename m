Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2HEW26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:28:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab2HEW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:28:57 -0400
Message-ID: <501EF3A2.20200@zytor.com>
Date: Sun, 05 Aug 2012 15:28:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>
CC: Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>, linux-efi@vger.kernel.org
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
In-Reply-To: <20120805172903.5f8bb24c@zougloub.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 02:29 PM, Jérôme Carretero wrote:
> Hi,
>
> My PC (AMD Bulldozer + Asus SABERTOOTH 990FX) booted fine from UEFI
> and it broke between v3.5 and v3.6-rc1.
> Other machines with old BIOSes booted fine so I looked into EFI-related
> patches trying to revert them, because I didn't know what else to do.
>
> Bingo, bacef661: x86-64/efi: Use EFI to deal with platform wall clock.
>
> At the moment I reverted this commit after v3.6-rc1-133-g42a579a,
> and it boots fine.
>
> This really not my domain so tell me if I can help testing.
>

Thank you... we were aware of the problem but had not been able to 
reproduce it, so we had hoped someone would bisect or otherwise identify 
the faulty patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

