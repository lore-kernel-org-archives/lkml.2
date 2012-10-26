Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2JZSyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:54:01 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36837 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2JZSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyS_iJcKz=-zSDK+bjYiNeEzy4T5FrrGL8HBsxTOSwpJQ@mail.gmail.com>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com> <20121026144615.2276cd59@dull> <CA+55aFyS_iJcKz=-zSDK+bjYiNeEzy4T5FrrGL8HBsxTOSwpJQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 11:53:37 -0700
X-Google-Sender-Auth: PoqdxoJyYSBYdSSWFLTAbG-Dn5Y
Message-ID: <CA+55aFyfSpLiLKS3ptOBxEc_WRvhmtMmCEoAEbEj=Sxahe56ow@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm,generic: only flush the local TLB in ptep_set_access_flags
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

On Fri, Oct 26, 2012 at 11:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> NOTE: It's *not* "access permissions". It's "access flags".
>
> Big difference. This is not about permissions at all.

Anyway, modulo the misleading commit messages, ACK from on the series.

                 Linus
