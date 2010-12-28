Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0L1UM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:12:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56619 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0L1UM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:12:26 -0500
Message-ID: <4D1A449F.50002@zytor.com>
Date: Tue, 28 Dec 2010 12:12:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Len Brown <lenb@kernel.org>, Jack Steiner <steiner@sgi.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "tony.luck@gmail.com" <tony.luck@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gbeshers@sgi.com" <gbeshers@sgi.com>
Subject: Re: [PATCH] ACPI: use ioremap_cache()
References: <20101214220932.GA1206@sgi.com>	 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>	 <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com>	 <alpine.LFD.2.00.1012151536510.21167@x980>	 <alpine.LFD.2.00.1012162149370.20940@x980>	 <alpine.LFD.2.00.1012170307080.20940@x980>	 <1293506460.10593.43.camel@sli10-conroe>  <4D195AFF.9020106@zytor.com> <1293512540.10593.46.camel@sli10-conroe>
In-Reply-To: <1293512540.10593.46.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2010 09:02 PM, Shaohua Li wrote:
>>
>> For x86, that is handled by the MTRRs; 
> does it cause any problem if the pat and mtrr doesn't match?
> 

No, the interaction rules between PAT and MTRR are well-defined; see the
SDM 3A.  If they weren't we would have huge problems with SMM.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

