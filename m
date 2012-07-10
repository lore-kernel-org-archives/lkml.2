Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2GJAMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:12:38 -0400
Received: from ozlabs.org ([203.10.76.45]:33356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab2GJAMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:12:37 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Jason Vas Dias <jason.vas.dias@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Comrade DOS <suloevdmitry@gmail.com>
Subject: Re: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before temperature or vice versa dependant on new "temp_b4_trip" module parameter to support older AMD x86_64s
In-Reply-To: <CALyZvKxP793Qq5-SHt1ExfivHWhNeMOgVWD6qDsQ0kjEBOA96w@mail.gmail.com>
References: <CALyZvKyEiTaU4CDh3F-fYkSjyyFkmhjitaWmXs_PORVEeOnirw@mail.gmail.com> <87bojp3hek.fsf@rustcorp.com.au> <CALyZvKxP793Qq5-SHt1ExfivHWhNeMOgVWD6qDsQ0kjEBOA96w@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 10 Jul 2012 09:36:48 +0930
Message-ID: <87hatgqy1z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 19:16:24 +0100, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> Thanks Rusty - sorry I didn't see your email until now - revised patch
> addressing your comments attached -
> BTW,  sorry about the word wrap on the initial posting - should I
> attach a '.patch' file or inline ?  Trying both .

The inline one was wrapped.

> +static int thermal_temp_b4_trip(const struct dmi_system_id *d) {
> +
> +       printk(KERN_NOTICE "ACPI: %s detected: : "
> +                           "getting temperature before trip point
> initialisation\n", d->ident);
> +       temp_b4_trip = TRUE;
> +       return 0;
> +}

TRUE?  true is standard with stdbool.h.

The patch itself looks reasonable, but it's not my area: I just spotted
the module_param() abuse :)

Cheers,
Rusty.
