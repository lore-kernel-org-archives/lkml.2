Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FSBvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 21:51:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab0FSBvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 21:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sduxn+4Tx6o+GVp06QytlfcDZ1TYoO6WhldldT/7ZVQ5bl3ZFOCb9Wjbp8CJ8wE8N8
         NEO2ThZyly+EAVXpOWtVFsc4f7ptl8Y4cHdvD/SPqVsayAcrLlP+bln7Qh3Y7iWtrzgC
         ul6/1KEm2dF4zP6GMIxZ/5A7a8CTGL84nbrOE=
MIME-Version: 1.0
In-Reply-To: <1276875067.1875.133.camel@laptop>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	<20100612102558.GA4000@elte.hu>
	<4C15A5D1.1040104@jp.fujitsu.com>
	<20100618094838.GD23977@elte.hu>
	<AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
	<20100618124551.GC7612@elte.hu>
	<AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
	<20100618143532.GA10886@elte.hu>
	<AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
	<1276875067.1875.133.camel@laptop>
Date: Sat, 19 Jun 2010 09:51:01 +0800
Message-ID: <AANLkTilwPmIdrueWHLqK5VJpdYSOuSXhBh6gQ209NZAY@mail.gmail.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 11:31 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-06-18 at 23:16 +0800, huang ying wrote:
>>
>> soft_irq is a delayed mechanism for IRQ,
>
> No its not.

Why? What do you think soft_irq is for?

>>  a self interrupt can be a
>> delayed mechanism for NMI. If we can make soft_irq NMI-safe,
>
> No you can't.
>
>> we can
>> use soft_irq as a backup of self interrupt (for systems without APIC
>> and maybe for other architectures).
>
> Whatever would you want to do that for.

Best Regards,
Huang Ying
