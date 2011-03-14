Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1CNP4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:56:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1CNP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=T/ve3AR1I+bP3RVzAOAjy0Iwl6Idc63BVe/Psi5KabPZMlPm32u3bZZ2BcSIGcb3kZ
         kiTpwRF6+7SsHtq7f/qQ==
From: Ian Lance Taylor <iant@google.com>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <sedat.dilek@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, <amodra@gmail.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "binutils" <binutils@sourceware.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
	<4D7E095802000078000363D5@vpn.id2.novell.com>
	<AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
	<AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
	<4D7E166C0200007800036451@vpn.id2.novell.com>
Date: Mon, 14 Mar 2011 08:56:29 -0700
In-Reply-To: <4D7E166C0200007800036451@vpn.id2.novell.com> (Jan Beulich's
	message of "Mon, 14 Mar 2011 12:21:48 +0000")
Message-ID: <mcrtyf53dci.fsf@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <JBeulich@novell.com> writes:

> No - $(AS) isn't being used to translate .S files, $(CC) is being used
> instead. That's why I pointed at the necessary -B option (so that
> the compiler would be able to locate the wrapper H.J. suggested).

You could also just put a -Wa option in your $(CC).  That seems simpler
than a -B option.

(I don't really care about this issue one way or another.)

Ian
