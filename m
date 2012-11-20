Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2KTRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:09:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42354 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2KTRJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:09:27 -0500
Message-ID: <50ABB92D.5090401@zytor.com>
Date: Tue, 20 Nov 2012 09:09:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
References: <20121117151611.GB16900@elgon.mountain> <20121120004834.GE5060@sgi.com> <20121120042855.GE6186@mwanda> <20121120111055.64845785@pyramind.ukuu.org.uk> <20121120162706.GB11150@sgi.com>
In-Reply-To: <20121120162706.GB11150@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 08:27 AM, Russ Anderson wrote:
>
> I very much agree.  I prefer u32, u64 (etc) because they are
> unambiguous.  It removes all doubt as to the actual meaning.
>
> Conversly, the fact that "long" has different meanings makes
> it at best problematic.  Was the code written assuming "long"
> was 32 or 64 bits?  Having data types that can have different
> sizes is just asking for trouble.
>

In the Linux kernel context, "long" effectively means the native size 
(size_t/intptr_t/ptrdiff_t).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

