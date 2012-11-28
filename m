Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2K1TnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:43:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52881 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2K1TnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121128171558.GM21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<1353123563-3103-16-git-send-email-yinghai@kernel.org>
	<20121128171558.GM21266@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 11:43:01 -0800
X-Google-Sender-Auth: rzTpiQRxAPJzPLXbl8ztZr0X66U
Message-ID: <CAE9FiQXrfviUbV28ZoGkNYv7HPf+e_j-z7+-E+weuRfpJmq+4g@mail.gmail.com>
Subject: Re: [PATCH v8 15/46] x86, mm: Only direct map addresses that are
 marked as E820_RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 9:15 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> -v4: fix add_pfn_range_mapped() to get correct max_low_pfn_mapped when
>>      mem map does have hole under 4g that is found by Konard on xen
>                                                         ^^^^^^-> Konrad

===>

-v4: fix add_pfn_range_mapped() to get correct max_low_pfn_mapped when
     mem map does not have hole under 4g that is found by Konrad on xen
     domU with 8g ram. - Yinghai
