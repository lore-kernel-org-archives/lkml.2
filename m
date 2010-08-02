Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0HBU2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:28:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36918 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0HBU2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:28:40 -0400
Message-ID: <4C572A13.4010303@zytor.com>
Date: Mon, 02 Aug 2010 13:26:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek <konrad@hera.kernel.org>, torvalds@linux-foundation.org,
        James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
        pjones@redhat.com, lenb@kernel.org, michaelc@cs.wisc.edu
Subject: Re: [GIT PULL] iBFT features for v2.6.36
References: <20100802143642.GA15428@hera.kernel.org> <4C570CDD.5070304@zytor.com> <20100802195248.GB32503@andromeda.dapyr.net>
In-Reply-To: <20100802195248.GB32503@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 12:52 PM, Konrad Rzeszutek Wilk wrote:
>>
>> Unfortunately, we're increasingly seeing a proliferation of this kind of
>> nonstandard ACPI tables, because it is difficult to add data to ACPI at
> 
> Keep in mind that iBFT is now a standard (woot!)
> 

Yes, but the discovery method is ad hoc, as opposed to the standard ACPI
mechanisms.

>> runtime.  gPXE creates an aBFT table for AoE and sBFT for SRP, and
>> memdisk uses mBFT for MEMDISK at the moment.
> 
> Oh man, didn't know those existed at all.
>>
>> It would be good to have some kind of common structure framework for these.
> 
> I need to grok those tables some more to figure out what they all do.

More or less the same thing as iBFT, but for AoE, SRP, or in-memory disk.

	-hpa
