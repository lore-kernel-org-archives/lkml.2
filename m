Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0FUQLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:11:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab0FUQLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:11:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=j0lYiA32WRcov4M+2wLmN6P4Pgm84gyMbQzp7QmgrKKZV0U24MzoyGXmWqjgUb0T+
	pTJF21UC6gdieNbeMS2IQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimt6HQZVeTtv_UO-5Lt4ngtPr0cyNXkq2YGR3lA@mail.gmail.com>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
	<alpine.DEB.1.00.1006191622450.14879@tigran.mtv.corp.google.com>
	<AANLkTimt6HQZVeTtv_UO-5Lt4ngtPr0cyNXkq2YGR3lA@mail.gmail.com>
Date: Mon, 21 Jun 2010 09:11:23 -0700
Message-ID: <AANLkTil8umNYwlc1FUZJaGv2ObTLG37rHEmIgxfJAUqB@mail.gmail.com>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
From: Hugh Dickins <hughd@google.com>
To: mtk.manpages@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 10:36 PM, Michael Kerrisk
<mtk.manpages@gmail.com> wrote:
> On Sun, Jun 20, 2010 at 2:02 AM, Hugh Dickins <hughd@google.com> wrote:
>> On Sat, 19 Jun 2010, Michael Kerrisk wrote:
>>> +The KSM daemon
>>> +.RI ( ksmd )
>>> +periodically scans those areas of user memory that have
>>> +been marked as mergeable,
>>> +looking for pages with identical content.
>>
>> I was rather puzzled by Andi calling that an internal implementation
>> detail.  Okay, I suppose the "KSM daemon periodically scans" is an
>> internal implementation detail, though I think it helps to warn the
>> programmer of the overhead of MADV_MERGEABLE; but without "pages
>> with identical content", aren't we left mystified as to just what
>> this "merging" is all about?
>
> I agree. All I had changed was to remove mention of the KSM daemon --
> I just say "the kernel".

Great, that's just right: thanks.

Hugh
