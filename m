Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966141Ab2JZTSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:18:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54482 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966098Ab2JZTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <508AE1A3.6030607@redhat.com>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com> <20121026144419.7e666023@dull>
 <CA+55aFwdcMzMQ2ns6-p97GXuNhxiDO-nFa0h1A-tjN363mJniQ@mail.gmail.com> <508AE1A3.6030607@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 12:18:16 -0700
X-Google-Sender-Auth: dEJXAdf72ZrQxcRdRKBFuCVMT9E
Message-ID: <CA+55aFxOywu=6pqejQi5DFm0KQYj0i9yQexwxgzdM5z3kcDgrg@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86/mm: only do a local TLB flush in ptep_set_access_flags()
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 12:16 PM, Rik van Riel <riel@redhat.com> wrote:
>
> I can change the text of the changelog, however it looks
> like do_wp_page does actually use ptep_set_access_flags
> to set the write bit in the pte...
>
> I guess both need to be reflected in the changelog text
> somehow?

Yeah, and by now, after all this discussion, I suspect it should be
committed with a comment too. Commit messages are good and all, but
unless chasing a particular bug they introduced, we shouldn't expect
people to read them for background information.

                    Linus
