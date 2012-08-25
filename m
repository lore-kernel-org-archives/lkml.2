Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2HYSe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:34:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36192 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab2HYSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <5037F317.7020606@zytor.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com> <5037F317.7020606@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Aug 2012 11:34:05 -0700
X-Google-Sender-Auth: SlnASoUVYcVi4cA3hyVRTv0n5Jw
Message-ID: <CA+55aFyjhLt0cJLOK+BoKaysA8KzSXj+L0gEpGxGU84Wok-5+A@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86, fpu: cleanups, introduce non-lazy FPU restore
 for xsave
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@kernel.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 2:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I have applied this to tip:x86/fpu, but I have also asked Suresh to
> prepare a followon patch to decouple eager save from the existence of
> the XSAVE instruction.  It seems pretty clear that eager save is a net
> benefit in the presence of the XSAVEOPT, but it isn't as clear for only
> having XSAVE, as far as I can tell.  Either way it would seem to be a
> policy decision that is somewhat separate from the exact instruction.

Agreed. It would also be good for testing bugs and/or performance for
both xsave and non-xsave cases.

          Linus
