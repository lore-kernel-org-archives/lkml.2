Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2J2PVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab2J2PVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:21:04 -0400
Message-ID: <508E9F5B.5010402@redhat.com>
Date: Mon, 29 Oct 2012 11:23:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] x86/mm: only do a local TLB flush in ptep_set_access_flags()
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl> <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com> <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com> <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com> <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com> <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com> <20121026132601.GC9886@gmail.com> <20121026144419.7e666023@dull> <CA+55aFwdcMzMQ2ns6-p97GXuNhxiDO-nFa0h1A-tjN363mJniQ@mail.gmail.com> <508AE1A3.6030607@redhat.com> <CA+55aFxOywu=6pqejQi5DFm0KQYj0i9yQexwxgzdM5z3kcDgrg@mail.gmail.com>
In-Reply-To: <CA+55aFxOywu=6pqejQi5DFm0KQYj0i9yQexwxgzdM5z3kcDgrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:18 PM, Linus Torvalds wrote:
> On Fri, Oct 26, 2012 at 12:16 PM, Rik van Riel <riel@redhat.com> wrote:
>>
>> I can change the text of the changelog, however it looks
>> like do_wp_page does actually use ptep_set_access_flags
>> to set the write bit in the pte...
>>
>> I guess both need to be reflected in the changelog text
>> somehow?
>
> Yeah, and by now, after all this discussion, I suspect it should be
> committed with a comment too. Commit messages are good and all, but
> unless chasing a particular bug they introduced, we shouldn't expect
> people to read them for background information.

Now that we have the TLB things taken care of, and
comments to patches 10/31 and 26/31 have been addressed,
is there anything else that needs to be done before
these NUMA patches can be merged?

Anyone, this is a good time to speak up. We have some
time to address whatever concern you may have.

(besides waiting for the next merge window)

