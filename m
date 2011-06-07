Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1FGAgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:36:22 -0400
Received: from r00tworld.com ([212.85.137.150]:53058 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1FGAgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:36:21 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 07 Jun 2011 02:34:42 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DED7222.28864.150079CE@pageexec.freemail.hu>
In-reply-to: <20110606192544.GA28947@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED239B.8177.13CDBA86@pageexec.freemail.hu>, <20110606192544.GA28947@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Tue, 07 Jun 2011 02:35:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 21:25, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > [...] it goes like 'I am not willing to do A because it would help 
> > script kiddies but I'd rather do B that would help script kiddies'. 
> > with A = 'disclose security bugs' and B = 'keep the last roadblock 
> > that prevents full ASLR'.
> 
> No, that's wrong, the logic goes like this:
> 
>   if i do A then it has X1 advantages and Y1 disadvantages.
>   if i do B then it has X2 advantages and Y2 disadvantages.
> 
> The Y1 and Y2 set of disadvantages can both include "making it easier 
> for script kiddies" but the sets of advantages and disadvantages can 
> also include MANY OTHER considerations, making the decision unique in 
> each case.

sure, i was only reflecting on what Linus himself kept insisting on in
the past.

> To translate it to this specific case (extremely simplifed, so please 
> don't nit-pick that my descriptions of advantages and disadvantages 
> are not precise nor complete):

i don't even need to get there, you already failed right in the very
first sentence, very impressive. no. 'not precise' is an understatement.

>  A) "i put a zero day exploit and a CVE code into a changelog"
> 
>      Advantages: - it describes the problem more fully
> 
>   Disadvantages: - it makes it easier for people (including script kiddies) do harm faster
>                  - creates a false, misleading category for "security bugs"
> 

you try to set things up to serve your argument but it's not the things
we've ever talked about (IOW, this is a strawman).

in particular, i've never ever requested exploits in commit logs (and i
don't remember anyone else who has, do you?). why do you keep thinking in
only extremes? is it so impossible to simply state a CVE and the generic
bug class (CWE) that the commit fixes? what Linus has insisted on is 'no
greppable words', that's diametrically opposite to 'full disclosure' that
you guys say you're supposedly doing.

so if you omit the exploits that noone really requested (and i don't even
know why they'd be useful in a commit) then suddenly the script kiddies
are no longer helped.

and you have yet to explain what is false and misleading about the security
bug category. you used these words yourself several times today, how do you
explain that? why does the CVE exist? why does bugtraq exist? are all those
people discussing 'false and misleading' things? why does your employer
release security errata? etc, etc.

>  B) "i obfuscate the vsyscall page"
> 
>      Advantages: - it makes it statistically harder for people (including script kiddies) to do harm
> 
>   Disadvantages: - it reduces the incentive to fix *real* security bugs

as i pointed out in an earlier mail, this supposed disadvantage doesn't
exist so come up with something better, preferably real.

>                  - complicates the code

removing code simplifies things. next try? ;)

> Do you see how A) and B) are not equivalent at all? Different cases, 
> different attributes, different probabilities and different 
> considerations.

i only see a strawman that you thought would help your cause but since
it's just that, a strawman, something you made up for the sake of argument,
i don't think there's much more to see about it.

> > but it's very simple logic Ingo.
> 
> Please drop the condescending tone, i think it should be clear to you 
> by now that i have a good basis to disagree with you.

i'm a firm believer of instant karma, it seems to work on people like yourself
or Linus really well. in somewhat profane but simple english: if you behave as
an asshole i will treat you as one, if you believe i treated you as an asshole
it's because i think you acted as one, and if you don't understand why then you're
welcome to 1. look into yourself and figure it out yourself, 2. ask me. what is
not going to get you anywhere is if you talk to me and others from the high horse,
you must be a lot better than your current self for anyone to tolerate it.

