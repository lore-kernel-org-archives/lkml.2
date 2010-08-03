Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0HCOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0HCOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:33:20 -0400
Message-ID: <4C582918.5080602@redhat.com>
Date: Tue, 03 Aug 2010 10:35:04 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org, michaelc@cs.wisc.edu,
        mcb30@ipxe.org
Subject: Re: [GIT PULL] iBFT features for v2.6.36
References: <20100802143642.GA15428@hera.kernel.org> <20100802195248.GB32503@andromeda.dapyr.net> <4C572A13.4010303@zytor.com> <201008022108.04024.konrad@kernel.org> <4C577EFA.4070003@zytor.com>
In-Reply-To: <4C577EFA.4070003@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 10:29 PM, H. Peter Anvin wrote:
> On 08/02/2010 06:08 PM, Konrad Rzeszutek Wilk wrote:
>>
>> Can you point me what 'standard ACPI mechanism' is? Like sticking
>> the code in the drivers/acpi ? And then having a generic driver to
>> handle the [i,a,s,m]BFT tables and maybe some subordinate ones for
>> specific pieces where the generic can't handle it?
>>
> 
> With the standard ACPI mechanism I meant RDSP -> {RSDT,XSDT} -> table.
> If it was easily possible to add SSDTs to this table structure then
> probably the best thing would have been to make them PnP devices.

The current iBFT specification and the current code (this push) includes the
ability to specify the location of the iBFT table using the standard ACPI table
mechanism, which is required on UEFI machines supporting iBFT, and which I
would encourage non-UEFI machines to also use where possible.  Obviously some
systems, especially BIOS-based machines doing iSCSI boot on expansion cards,
have difficulty with this, so we're not planning on de-supporting the old
memory scanning method.

-- 
        Peter

Obviously, a major malfunction has occurred.
		-- Steve Nesbitt, voice of Mission Control, January 28, 1986

01234567890123456789012345678901234567890123456789012345678901234567890123456789
