Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab2LVFKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:10:34 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45160 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2LVFKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:10:32 -0500
MIME-Version: 1.0
In-Reply-To: <87bodmhkns.fsf@xmission.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-25-git-send-email-yinghai@kernel.org>
	<20121222023741.GF3468@phenom.dumpdata.com>
	<87bodmhkns.fsf@xmission.com>
Date: Fri, 21 Dec 2012 21:10:30 -0800
X-Google-Sender-Auth: OqyZ9yUhb1phGwkF3uC4drO7Wic
Message-ID: <CAE9FiQV9_A3BX=vdQLzk4kUf8bfbBWR3ihtC+GfM+9Tj_ZysVQ@mail.gmail.com>
Subject: Re: [PATCH v7 24/27] x86: Add swiotlb force off support
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 6:42 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
>
>> On Mon, Dec 17, 2012 at 11:15:56PM -0800, Yinghai Lu wrote:
>>> So use could disable swiotlb from command line, even swiotlb support
>>> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.
>>
>> You really need to spell out why this is useful.
>
> YH why can't we safely autodetect that the swiotlb is unusable when
> there is no memory below 4G free?

good point.

will give it try.

Yinghai
