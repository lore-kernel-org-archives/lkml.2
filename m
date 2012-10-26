Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2JZSuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:50:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59490 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab2JZSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121026144419.7e666023@dull>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com> <20121026144419.7e666023@dull>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 11:49:42 -0700
X-Google-Sender-Auth: s9vccQxju57GYF5lRncvojVHA-A
Message-ID: <CA+55aFwdcMzMQ2ns6-p97GXuNhxiDO-nFa0h1A-tjN363mJniQ@mail.gmail.com>
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

On Fri, Oct 26, 2012 at 11:44 AM, Rik van Riel <riel@redhat.com> wrote:
>
> The function ptep_set_access_flags() is only ever invoked to upgrade
> access permissions on a PTE

Same deal. Please don't call these "access permissions". That confuses
the issue.

           Linus
