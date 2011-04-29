Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab1D2RR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:17:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60891 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983Ab1D2RR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Vs5NmJ2dMYQgsxVX1gp1oBJ8gyQvTFtdqVfYYWZ4nQgo7fzg/khiyXV/PMkzsb6AHu
         sOW8atYEVaqj++TwyHX2YdQ6ZSd9M+dhS1sZ+hn4VnVfDe83Ox5TQV9J8zu2OhdIZ5pZ
         gtrsaBSCP317TNOSEvGHsj636zor28WGnaEOw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
Date: Fri, 29 Apr 2011 20:17:24 +0300
X-Google-Sender-Auth: BNp2_2Tibtv6OcR_eoOniKhLFEc
Message-ID: <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
From: Pekka Enberg <penberg@kernel.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Fri, Apr 29, 2011 at 6:04 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> Hello Linus
>
> can you revert the commit b52c55c6a25e4515b5e075a989ff346fc251ed09
>
> This removed functionality from perf_events that allowed raw event access
> for OFFCORE_EVENTS type events on Nehalem and Westmere cpus.
>
> To be fair, this is not technically a regression as the feature was only
> (finally!) added in the 2.6.39 merge window.  However this is a useful
> feature and many tools (including the PAPI performance counter library
> that I work on) had added support for it in anticipation of the 2.6.39
> release.
>
> Ingo's reasons for removing the feature seem to boil down to
>  1.  "perf" doesn't use the functionality, and any other userspace
>      program that uses the perf_events syscalls don't matter
>  2.  Users are too stupid to use the raw functionality properly;
>      we should only allow a kernel-developer-approved small subset
>      of the features provided by the CPU as described in the intel
>      developers manuals.
>
> #2 seems like a gross misinterpretation of the whole "Linux gives you
> enough rope to shoot yourself in the foot" policy from days passed, but
> maybe things have moved on.

That's a gross misrepresentation of what Ingo has been saying on LKML.
Really, learn to work with relevant maintainers before you ask Linus
to revert something.

                                Pekka
