Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2IRGk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:40:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60456 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2IRGky convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 18 Sep 2012 02:40:54 -0400
Message-Id: <50583394020000780009BF8B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 18 Sep 2012 07:40:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
 <5056F04B020000780009BAF9@nat28.tlf.novell.com>
 <20120917100046.GA32463@gmail.com>
 <CA+55aFwKkW7+Xv4-36JsbR7rDyorC8xcTsL_XnYCq=XNTZeJFw@mail.gmail.com>
 <50575855.8040308@zytor.com>
In-Reply-To: <50575855.8040308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.09.12 at 19:05, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Honestly, I don't see a reason to not do this unconditionally.  On
> anything but (pre-686-era) extremely old CPUs the cost of the extra
> prefix is zero.  On the really old CPUs the cost of the BSF instruction
> will dwarf the penalty cycle for the extra prefix, so the whole
> mechanism around doing it conditionally seems pointless.

I certainly don't mind re-submitting with the whole thing made
unconditional (implying that the prior version would be dropped
in any case).

Jan

