Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab0FRNkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:40:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59621 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab0FRNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XqXkD4nn+aejI3tXyiRKQy/sQZtPuDhWNt1nht/flwRvomMjDagIUm8BT6CCktlB4K
         a2j/8x3ojLQznU7CIuC9g7q0agj7JkQ2X4lZBhNh4fuyv/Jb/H2zIDxuvLg/+SmtJsZn
         dTTLtAOJMCwlwQhqmZfQZ4wrmEWJwr13j3E2o=
MIME-Version: 1.0
In-Reply-To: <20100618124551.GC7612@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	<20100612102558.GA4000@elte.hu>
	<4C15A5D1.1040104@jp.fujitsu.com>
	<20100618094838.GD23977@elte.hu>
	<AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
	<20100618124551.GC7612@elte.hu>
Date: Fri, 18 Jun 2010 21:40:41 +0800
Message-ID: <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 8:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> [...] ??At least APEI will use NMI to report some hardware events (likely
>> >> error) to kernel. ??So I suppose we will go to have a delayed call as an
>> >> event handler for APEI.
>> >
>> > Yep, that makes sense. I wasnt arguing against the functionality itself, i
>> > was arguing against the illogical layering that limits its utility. By
>> > making it part of perf events it becomes a generic part of that framework
>> > and can be used by anything that deals with events and uses that
>> > framework.
>>
>> I think the the 'layering' in the patchset helps instead of 'limits' its
>> utility. It is designed to be as general as possible, so that it can be used
>> by both perf and other NMI users. Do you think so?
>
> What other NMI users do you mean? EDAC/MCE is going to go utilize events as
> well (away from the horrible /dev/mcelog interface), the NMI watchdog already
> did it and the perf tool obviously does as well. There's a few leftovers like
> kcrash which isnt really event centric and i dont think it needs to be
> converted.

But why not just make it more general? It does not hurt anyone including perf.

Best Regards,
Huang Ying
