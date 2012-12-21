Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2LUXw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:52:59 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62712 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2LUXwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <20121221233942.GA2000@phenom.dumpdata.com>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
	<1354089042-10023-13-git-send-email-yinghai@kernel.org>
	<20121221222619.GA1102@phenom.dumpdata.com>
	<CAE9FiQXsi5gj6QGp-rreH6Bqb6A5WTA6umFiiJ1mQFRp6u5ziw@mail.gmail.com>
	<20121221233942.GA2000@phenom.dumpdata.com>
Date: Fri, 21 Dec 2012 15:52:53 -0800
X-Google-Sender-Auth: lqYk_pzlEH0Z-i37l68I5WddVsU
Message-ID: <CAE9FiQWwS=71dKBkSOHb5GEMfsRvSTo25A1jZ2+EhYwFo-Yo6g@mail.gmail.com>
Subject: Re: [PATCH v5 12/13] x86, 64bit: Print init kernel lowmap correctly
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 3:39 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Dec 21, 2012 at 02:44:39PM -0800, Yinghai Lu wrote:
>>
>> maybe we can change the subject of this patch to:
>>
>> Subject: [PATCH] x86, 64bit: Don't set max_pfn_mapped wrong on native boot path
>
> Or the inverse.
>
> Set max_pfn_mapped correctly on non-native boot path?
>
> But this patch is not actually touching max_pfn_mapped - it is vaddr_end?

No,

it is 0 for native path


> So maybe:
>
> Subject: For platforms to set max_pfn_mapped, take that under advisement when blowing away __ka page entries.

hard to understand.
