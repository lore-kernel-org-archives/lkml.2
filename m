Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2FYAdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 20:33:50 -0400
Received: from nm4-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.138]:47022
	"HELO nm4-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751537Ab2FYAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 20:33:47 -0400
X-Yahoo-Newman-Id: 879644.45897.bm@smtp110.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pDJHqoYVM1lZysjcDf0UuDfL1ZLtuCrVIxP5ebooDJvqLrf
 l0pWHS3KaKdS5R5pLzcYM124_P.PCtZeu0HIC.rm0PKr32FZCq5yUU76LVeC
 _QOizW6R80IoiDszpq1lyJGJ81CIhkpe6IYYxUU5g2Gu7fKViPPBNaNvvgLb
 67FiSpURmXCydWUm043.kUsiPrHjQm6cTh43OuA1fxOgelMZ8KmDs9NtqoOe
 jxkOXS7zVh19G0HvOP69dpasnCs1agVhY.dypCkMI3Qy3ILvmDQjIoTzK87V
 aDoWSRu8UGFWhiJRg7aAbspBeAlq7IYQ.QGeR_Ib3T8rzV2zGlweFdP46LPE
 W2sfBWGx0ua.n1w9dluqFexqDe2lCR9wbZGvtX.1jX.w6FCZ1kmIjyqUG4qj
 M1gdnSvYr1sVYzZ8tTu9kAPWFUHJP9tW_G3Jwv9_LT271gemzG5vdFv4QwvK
 vjhnub5uQiy7994DknfWqK8vnFiTHE_xTgADV_OSLtQfWx1Srnjl6IpQvIzj
 UjuVHyggQ6Axk3.e08qJA.bSQ2hMMs50RLjjQ31RcoZvJgko4AaTyd3_qQKn
 56p_Tz3rYPbVv6GFOyT2SB2rCC8XE.eYSbq7iI797T2VTN9tgM9QuAcDbdgW
 nfP2ZgYklPmlQj2ht0pI14MZoV72tIDxI7lOpN22f8nQN7JwMbUXS2Ay6jBd
 s4Q01r3IFYHzQ.g--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FE7B1E8.4030002@att.net>
Date: Sun, 24 Jun 2012 19:33:44 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <4FE64AB4.1010904@landley.net> <4FE661F8.3000109@att.net> <4FE69A14.6040904@landley.net>
In-Reply-To: <4FE69A14.6040904@landley.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

Thank you for the education.  I wasn't up on the "anti-tivoization"
issue, but after reading up I would have to say that I'm deeply in that
camp; if I buy the hardware, I should be able to do what I damn well
please with it -- why I haven't purchased an iphone for example.    At
the same time, I also believe in GPL w/link-time exception if the
situation warrants it.  But this is a discussion for another time & place.

On 06/23/2012 11:39 PM, Rob Landley wrote:
> Less optimized but still works with old compilers is fine. (Less
> optimized comes with the territory with old compilers.) 
This was of particular concern to be because of how much less
optimized.  For example, an inline function that expanded to about 128
bytes on gcc 4.6 expanded to 500-ish bytes on gcc 3.4.6.  I guess I
should reserve any further comment until I have hard performance numbers.
> And who's talking "if"?
>
> LLVM/CLANG builds a bootabe linux kernel:
> http://lwn.net/Articles/441018/
>
> Open64 builds a bootable linux kernel:
> http://article.gmane.org/gmane.comp.compilers.open64.devel/2498
>
> The PCC guys make an adorable token effort which is largely ignored:
> http://bsdfund.org/bundle/
>
> Heck, Fabrice bellard did it himself with tinycc back in 2004:
> http://bellard.org/tcc/tccboot.html
Frankly, I'm glad to hear about these endeavors.  I'm not a fan of Apple
because of their business policies, but I'm a huge fan of run-time
optimization being a hard-core Java programmer (and yes, I admit it :). 
I did check out tccboot at one point out of interest.
>> Another question that has to be asked is "Is Linux ready for this?"  The
>> answer today may be "yes" or "no", but to say that it can never be ready
>> is pure folly.
>
> I'm saying that adding complexity is not necessarily an improvement, and
> that over-optimizing at the expense of portability may turn out to be a
> mistake in the long run.
Any time you want to add complexity, it must be justified. However, I'm
operating by the compiler compatibility rules adopted by the Linux
kernel project and putting portability (to non-gcc compilers) as a lower
concern than the 99% use case.
> You keep using the word "paradigm". Voluntarily. I find this odd.
I don't tend to back away from a word just because PHBs (Pointy-Haired
Bosses) like to abuse them.  I'll even use the word "synergistic" when I
think it applies.  What I'm proposing introduces a few new paradigms,
patterns or schools of thought(and I prefer to pronounce it
"pair-uh-dig-uh-me", just because I can).

For one, I'm asking people to use a macro where you leave parameters
empty as a sort of "default" value.  This isn't standard and if I'm
going to ask somebody(especially lots of people) to do something
non-standard I want to make sure I've explored it thoroughly, eliminated
all other options and that there's a really good reason for doing so. 
If I can prove that there's a good reason for doing it, that there are
no other reasonable options, that it has a benefit and is reusable, then
we're using a new paradigm and we have to start thinking about the
interface differently than we're used to thinking about interfaces. 
Many consider this out-right macro abuse -- that is a valid school of
thought.  I'm introducing this as an alternate school of thought.

But the other paradigm that seems to be new is using constant function
pointers for a sort-of "type-injection" for generic inline functions. 
We usually think about function pointers as overhead.  But since gcc's
-findirect-inlining feature has matured, it creates the opportunity for
a new way of thinking about the use of function pointers (when they are
constant) for generic code.  I prefer the term "paradigm" when mechanism
requires a distinct way of thinking about the mechanism and its
components and can be re-used as a pattern.

> So yay standard C99 micro stuff. I'm a little worried about being able
> to unwrap it all and understand what's going on, but unlike templates
> we have cc -E to fall back on here, so ok.
I have (or had) a script somewhere around here to parse that huge
one-line macro out and give it some reasonable linebreaks & indentation
(feeding it gcc -E).  Developing complex pre-processor stuff is a super
pain, so I just want to make sure that using it is as painless as possible.
> Ok, so "designed with gcc 4.6's optimizer in mind, regression tested back to 3.4 for at least minimal functionality, and not intentionally breaking other compilers".
>
> That's what I wanted to know, and it sounds good to me.
Yes.  I wouldn't think it appropriate to propose the patch set if it
degraded performance with a fairly recent compiler (stable).  Although,
gcc 4.6.3 still isn't considered "stable" on Gentoo because there's
still a few (10-ish) broken packages blocking it.

Daniel


