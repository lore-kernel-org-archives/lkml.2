Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0E1T71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:59:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58602 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0E1T7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:59:24 -0400
Message-ID: <4C00205F.9060505@zytor.com>
Date: Fri, 28 May 2010 12:58:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 0/2] sys_personality fixes v2
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org> <20100528191139.GB12090@redhat.com> <alpine.LFD.2.00.1005281228050.11382@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005281228050.11382@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 12:28 PM, Linus Torvalds wrote:
> 
> 
> On Fri, 28 May 2010, Oleg Nesterov wrote:
>>
>> I am just resending Linus's patch + another one with the minor cleanup.
>>
>> 1/2 lacks the "From: Linus" tag, but this is only because I'm afraid he
>> won't be proud by the changelog I wrote.
> 
> Ack to both, and I don't care if the first one gets put down as mine or 
> not, it's obviously trivial.
> 
> Who wants to merge them? Do I just take them directly, or what?
> 

That would make most sense to me.

Feel free to add my

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
