Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3ACVkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:40:36 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:49246 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3ACVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:40:14 -0500
MIME-Version: 1.0
In-Reply-To: <50E54A14.5010909@suse.cz>
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
 <87ip7f5ecu.fsf@rustcorp.com.au> <50E54A14.5010909@suse.cz>
From: Jonathan Kliegman <kliegs@chromium.org>
Date: Thu, 3 Jan 2013 16:39:52 -0500
Message-ID: <CAPQV+nOTEfeQVwqd8zAP37qS3PrdwFQv1c0AC=nAz3UCemXhSg@mail.gmail.com>
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches fatal
To: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 4:06 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> Dne 3.1.2013 00:56, Rusty Russell napsal(a):
> > Jonathan Kliegman <kliegs@chromium.org> writes:
> >> The section mismatch warning can be easy to miss during the kernel build
> >> process.  Allow it to be marked as fatal to be easily caught and prevent
> >> bugs from slipping in.
> >>
> >> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
> >
> > Hmm, a CONFIG option with no Kconfig entry?  That seems weird...
>
> With a Kconfig entry, all{mod,yes}configs would start failing. It can be
> enabled with make CONFIG_SECTION_MISMATCH_FATAL=y for now. Maybe it
> could be added to Kconfig with 'depends on n', so that it is documented
> somewhere.
>
Sorry for missing the Kconfig entry.  It looks like init/Kconfig in
the "General setup" seems the best fit as that looks like where the
other build options are.  If this is ok I'll upload a new version of
the patch with the entry added.

I'm not sure what you mean about configs failing.  After adding this
option to init/Kconfig I was able to build fine using old and new
configs with and without the option set.  Is there something specific
you'd like me to test for?

> Michal
