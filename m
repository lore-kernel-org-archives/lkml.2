Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2AQRim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:38:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58023 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2AQRil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:38:41 -0500
Message-ID: <4F15B1EA.4060405@zytor.com>
Date: Tue, 17 Jan 2012 09:37:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Len Brown <lenb@kernel.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: Re-add ibft tree to linux-next please
References: <20111212145330.GA16278@andromeda.dapyr.net> <4EE68D57.7030603@zytor.com> <20111213021536.GC2730@konrad-lan> <4F1580DE.1060002@kernel.org> <20120117164920.GA5111@phenom.dumpdata.com>
In-Reply-To: <20120117164920.GA5111@phenom.dumpdata.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 08:49 AM, Konrad Rzeszutek Wilk wrote:
>>
>> Are there really hardware/firmware configurations that support IBFT
>> and do not support ACPI?
> 
> gPXE can be used in legacy environments. And it (gPXE) does not update
> the ACPI tables.
> 

That's irrelevant.  THe point is that iBFT *is* an ACPI table.

> I think that would work. And also if 'acpi_disabled=0' as you might
> have an IBFT table in memory that is _not_ hooked up to the ACPI tables.

That is *always* the case, the "finder" is nonstandard (because the ACPI
tables are largely non-extensible, says the one who has tried to
actually extend ACPI tables in memory.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

