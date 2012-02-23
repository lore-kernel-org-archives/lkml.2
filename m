Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2BWAOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:14:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53243 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab2BWAOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:14:48 -0500
Message-ID: <4F4584EB.9060605@zytor.com>
Date: Wed, 22 Feb 2012 16:14:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <4F456D8F.1080801@zytor.com> <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com> <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
In-Reply-To: <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 03:31 PM, Linus Torvalds wrote:
> On Wed, Feb 22, 2012 at 3:15 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Ok, I probably missed something when I skipped the patches that
>> weren't appropriate for backporting (like the whole FPU state preload
>> removal and rewriting).
> 
> Ahh. Yes, I see what happened.
> 
> The FPU preloading patches cleaned up __switch_to() to use the
> appropriate helpers to set TS_USEDFPU, but since I skipped them
> (because I felt they weren't appropriate for -stable), those cleanups
> got missed. So then the __math_state_restore()
> 
> Only the last patch needs fixing, methinks. Updated version attached.
> 
>                     Linus

Immediate failure, still.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

