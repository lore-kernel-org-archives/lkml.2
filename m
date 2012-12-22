Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918Ab2LVFBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:01:03 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:32942 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2LVFBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121222021813.GC3468@phenom.dumpdata.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-25-git-send-email-yinghai@kernel.org>
	<20121222021813.GC3468@phenom.dumpdata.com>
Date: Fri, 21 Dec 2012 21:00:56 -0800
X-Google-Sender-Auth: Fv25A-6GUGERHopr6XbQUaewlsc
Message-ID: <CAE9FiQVARkz1_kuCF7L9ufaROQ0EyoyrTjJCsmK7JynepXe=Yw@mail.gmail.com>
Subject: Re: [PATCH v6 24/27] x86: Add swiotlb force off support
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 6:18 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Dec 13, 2012 at 02:02:18PM -0800, Yinghai Lu wrote:
>> So use could disable swiotlb from command line, even swiotlb support
>> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.
>
> Does this have any usage besides testing?

for kdump.

>
> And also pls in the future use scripts/get_maintainer.pl so
> that you can extract from the email of the maintainer (which would be me).
ok.
