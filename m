Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2JJO7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:59:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62895 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2JJO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121010134854.GC4005@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<1349827115-16600-5-git-send-email-yinghai@kernel.org>
	<20121010134854.GC4005@phenom.dumpdata.com>
Date: Wed, 10 Oct 2012 07:59:41 -0700
X-Google-Sender-Auth: lsQ0Zm9l8Sfl4Tm4WKf2zD9dTWc
Message-ID: <CAE9FiQWZqE0KWE4-y8c+Ybcy_d-bX4hw4iP-GvPW4rpzFUqu1g@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86, mm: only keep initial mapping for ram
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 6:48 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Tue, Oct 09, 2012 at 04:58:32PM -0700, Yinghai Lu wrote:
>> 0 mean any e820 type will be kept, and only hole is removed.
>>
>> change to E820_RAM and E820_RESERVED_KERN only.
>>
>
> This is good candidate for squashing in-to the previous patch, with
> verbose explanation why you care only about those two types.

two patches should be more safe.

new series will make sure only map RAM/RESEVED_KERN, so we should only
keep initial page table with those types.
