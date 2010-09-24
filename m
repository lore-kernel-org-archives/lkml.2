Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0IXTGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:06:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab0IXTGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:06:46 -0400
Message-ID: <4C9CF6A4.5020602@zytor.com>
Date: Fri, 24 Sep 2010 12:06:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Daniel Drake <dsd@laptop.org>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH 1/2] OLPC: Only enable PCI configuration type override
 on XO-1
References: <20100923162805.0F6549D401B@zog.reactivated.net> <20100924110338.18c8fe83@jbarnes-desktop>
In-Reply-To: <20100924110338.18c8fe83@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 11:03 AM, Jesse Barnes wrote:
> On Thu, 23 Sep 2010 17:28:04 +0100 (BST)
> Daniel Drake <dsd@laptop.org> wrote:
> 
>> This configuration type override is for XO-1 only and must not happen
>> on XO-1.5.
>>
>> Signed-off-by: Daniel Drake <dsd@laptop.org>
>> ---
>>
>> Replaces earlier patches:
>> [PATCH 1/3] OLPC: extended board revision detection
>> [PATCH 2/3] PCI: OLPC configuration cleanup
>>
>> Due to the fact that CONFIG_OLPC is associated with multiple laptop models
>> (not only the XO-1), it makes sense to keep this as a separate configuration
>> option.
>>
>> We decided against adding functions to distinguish between XO-1/XO-1.5 as
>> we don't want to encourage laptop checking in this way. There should only be
>> one or two cases where this actually matters (here is one of them).
> 
> Applied to linux-next, thanks.
> 

I already put these two patches into -tip, which should get it into
linux-next...

	-hpa

