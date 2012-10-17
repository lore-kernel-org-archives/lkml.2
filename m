Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2JQRf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:35:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab2JQRf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:35:27 -0400
Message-ID: <507EEC53.1010309@zytor.com>
Date: Wed, 17 Oct 2012 10:35:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI S3 and Xen
 (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com>
In-Reply-To: <20121017165452.GA22740@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 09:54 AM, Konrad Rzeszutek Wilk wrote:
>>
>> Could you do an audit for other pvops calls that have no users?  If
>> the *only* user is lguest, we should talk about it, too...
>
> I can do that - but I don't want to be hasty here. There is a bit of
> danger here - for example the read_pmc (or read_tsc) is not in use right
> now. But it might be when one starts looking at making perf be able to
> analyze the hypervisor (hand-waving the implementation details). So while
> removing read_pmc now sounds good, it might be needed in the future.
>

We do not keep a pvop around just because it "might be needed in the 
future".  That's just crazy.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

