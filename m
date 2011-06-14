Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1FNAup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:50:45 -0400
Received: from r00tworld.com ([212.85.137.150]:55134 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1FNAuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:50:44 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 14 Jun 2011 02:48:35 +0200
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
Message-ID: <4DF6AFE3.11023.3919B397@pageexec.freemail.hu>
In-reply-to: <20110610111932.GA30987@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.24457.19E64984@pageexec.freemail.hu>, <20110610111932.GA30987@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Tue, 14 Jun 2011 02:49:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Jun 2011 at 13:19, Ingo Molnar wrote:
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > let me tell you now a real distadvantage of your coverup: [...]
> 
> Our opinion is that the scheme you are suggesting [...]

why are you trying to make it 'my' scheme? it's not mine, i didn't come up
with it, it's what pretty much everyone else (other than you, that is) in
the world does, including your own employer, Red Hat.

i already asked you about this and you never responded so here it is again:
what do you think about Red Hat publishing security errata (including kernel
vulnerabilities)? with CVEs, description of fault, etc.

it's diametrically opposite to what you've been claiming so there seems to be
a disconnect here. do you actively disagree with your own employer's security
bug handling policy? you see, they're doing exactly what you're not willing to.

> [...] is flawed and reduces security, so we refuse to use it. That is not a
> 'coverup', to the contrary, it *helps* security - see below. 

yeah well, we'll see about it. it looks like year after year you guys manage
to outdo yourselves in absurdity, one wonders if there'll be a new category
needed for this year's pwnie awards because you're likely to no longer fit the
lamest vendor response category.

> > [...] you're hurting the good guys (the defenders) a lot more than 
> > you're hurting the bad guys (the attackers). why? because of the 
> > usual asymmetry of the situation we often face in security. an 
> > attacker needs to find only a single commit silently fixing a 
> > security bug (never mind finding the earlier commit that introduced 
> > it) whereas the defenders would have to find all of them.
> > 
> > thanks to your policy you can guess which side has a distinct 
> > advantage from the start and how well the other side fares.
> 
> Firstly, the asymmetry is fundamental: attackers *always* have an 
> easier way destroying stuff than the good guys are at building new 
> things. This is the second law of thermodynamics.

what garbage. both sides are building stuff! in fact, finding vulnerabilities,
writing exploits is an even higher level creation process than normal development
as it gives us knowledge well beyond what we'd have if we were doing only the
usual development. what extra knowledge is that? without this kind of research
we'd have to accept at face value a developer's claim (expressed in source code)
that he's just written code that does this or that.

the extra info we learn through all the work done by security research is whether
said code lives up to its developer's claims or not. e.g., whenever someone finds
a vulnerability that allows arbitrary code execution is basically a proof that a
Turing machine thought to be non-universal is actually a universal one. and with
a working exploit the proof is even machine verifiable. this is one of the rare
instances when we can actually pull such stunts off for non-trivial codebases in
fact.

i find it amazing that this fact is even up for debate when in another subfield
of security, cryptology, both sides (cryptography and cryptanalysis) are well
accepted and studied subjects in academic, commercial, military, etc settings
worldwide, without all the negative connotations that seem to plague vulnerability
research in some minds.

as for the asymmetry: whether it's present in all situations or not is something
you don't know because you don't know all situations (in fact, you seem to know
very little about this whole subject). since i tend to err on the side of safety,
i said 'usual' and 'often' just because i can't exclude the possibility of a
situation where such asymmetry is not present or is much less pronounced than
what we face with vulnerabilities and exploits.

> Secondly, you are missing one fundamental aspect: the 'good guys' are 
> not just the 'defenders'. The good guys are a *much* broader group of 
> people: the 'bug fixers'.

is this language lawyering? what do you think bug fixers do? they reduce the
attack surface of a system and therefore are part of the defender group.

> Thirdly, you never replied in substance to our arguments that CVE 
> numbers are woefully inadequate:

heh, i replied to you many times already but you didn't respond to dozens of
questions already (did you respond to this one because it was featured on LWN?).
the answers are all there Ingo, you just have to read them.

and it's never been about CVE per se btw, it was about 'some' information that
would help one reading the commit clearly understand that it's a fix for a
security bug, as far as the committer knew.

whether a CVE or similar piece of information is inadequate depends on what the
goal is. clearly, you're thinking in extreme black&white terms once again.
somehow you seem to believe that if you can't provide perfect and complete
information about security bugs then providing *no* information is somehow the
better choice? and better for what? end users' security? truly mind boggling!

> they miss the majority of bugs that can have a security impact.

you don't understand the whole purpose of CVE and similar information. it's not
about providing guaranteed full coverage about any and all vulnerabilities that
exist. that knowledge is kinda non-existent as far as we know. instead, CVE is
a mechanism that let's the world organize of what is *known* and communicate it
between all parties (vendors, developers, users, etc). your stubborn refusal to
even contemplate the idea of communicating your own knowledge to your own users
is very stupid and haven't earned you many friends out there (it, however, serves
as an excellent basis for every sales speech by every security vendor out there).

> In fact i argue that the way software is written and fixed today it's
> not possible to effectively map out 'bugs with a security impact' at
> all: pretty much *any* bug that modifies the kernel image can have a
> security impact. 

this is a strawman, noone asks for this kind of work as you're not even in the
position to be able to do this even if you tried. last but not least, it's also

  "not possible to effectively map out 'bugs that can cause filesystem
   corruption' at all: pretty much *any* bug that modifies the kernel
   image can cause filesystem corruption".

however that little fact somehow never prevented you guys from describing such
fixes in the commits which contradicts your desire to not give your users a false
sense of (filesystem) security. so if you want to follow your own words, you'll
have to *stop* letting the world know when you fix a known filesystem corruption
bug since based on what you argued so far, you can't guarantee that those are the
*only* such bugs/fixes. what's more, covering up filesystem corruption bugs will
also help everyone who has to backport them to their own supported kernels (for
yet to be explained reasons, i'm sure the world's dying to know now how they're
supposed to pull that off).

> Bug fixers are not at all concentrated on thinking like parasitic
> attackers, so security side effects often remain undiscovered.

noone ever expects it from them as it's never been a matter of concentration,
it's a matter of being skilled at it which you are not, there's nothing wrong
with it.

calling people who do the hard work of vulnerability research 'parasitic' shows
only how insecure (no pun intended) you feel about this whole situation: you
(presumably) do your best to write code and then comes someone out of the blue
and pokes a hundred holes in it and your subconscious self-defense begins to
distort your view of yourself and the others.

btw, would you call every respected cryptographer out there a parasite? because
that's what you effectively said.

> Why pretend we have a list of CVEs when we know that it's only fake? 

because CVEs are not about what you seem to think they are. knowing that a given
bug is exploitable is not 'fake', communicating it to your users is not 'fake'.
lying about it is however dishonest of utmost proportions. btw, how's all this
sit with the 'full disclosure' declared in Documentation/SecurityBugs? ever
thought of clearing it up?

> Fourth, exactly how does putting CVE numbers make it harder for 
> attackers?

a little help in reading comprehension of what i said:

> > you're hurting the good guys (the defenders) a lot more than 
> > you're hurting the bad guys (the attackers).

what (you think) makes life harder for attackers is *withholding* CVE or similar
information from commits, not their inclusion.

> It makes it distinctly *easier*: people will update their systems
> based on a list of say 10 CVEs that affect them, totally blind to the
> 100+ other bugs that may (or may not) have an effect on them. 

'people' are not updating their systems based on any list. 'people' update their
systems based on what their kernel supplier (vendor/distro/company's internal
team/etc) provides them with (there's an extreme minority of users who build
their own kernels of the latest vanilla tree).

now the big question becomes whether these suppliers are helped or obstructed by
your policy of covering up security fixes. given that pretty much none of them
supports the latest vanilla tree, not even -stable, it means that in order to
release new kernels they'll have to backport fixes. fixes that they don't even
know they should be backporting because of your covering them up. so what happens
is that everyone has to read every commit and do his best estimate whether it's
worthy of backporting or not (notice the waste of duplicated effort). don't you
think they could spend more time on finding actually important fixes if they
could skip over the already known ones and just backport them?

> An attacker will now only have to find an *already fixed* bug

what makes you think an attacker is interested at all in already fixed bugs?
who's gonna pay for an exploit against such a bug? that's not exactly where
the market is.

> that has a security impact and which didn't get a CVE and attack a 
> large body of systems that people think are safe.

people don't think that systems are safe just because there're no outstanding
CVEs against them (where did this idea come from?) because everyone who has ever
heard of CVEs knows about 0-day bugs as well (if for no other reason than the
simple fact that there're CVEs issued for 0-day bugs as they became public).

> With the current upstream kernel policy we do not deceive users: we 
> say that the way to be most secure is to be uptodate.

where do you say that?

what you do say is that you practice full disclosure though which you're
apparently not doing in practice as you cover up security fixes. besides, if,
as you said above, you don't actually figure out the security impact of all the
bugs you fix, what's the guarantee that the latest kernel (whatever up-to-date
means, git HEAD?) didn't introduce more bugs than it fixed? if you can't provide
such a guarantee (no, saying it is not it) then using the latest kernel is as
good as using anything else, if not worse (since older kernels at least had
more eyes scrutinize them by virtue of being around for longer).

the biggest flaw with your argument is that noone uses up-to-date kernels because
they have to rely on vendors/distros/etc. and for them to be able to produce an
up-to-date kernel they'd need to know the exact information that you're omitting.
so for the majority of users you make it impossible to be the most secure.

> Attackers will have to find an entirely new, not yet fixed security
> hole, instead of just a bug that missed the CVE filter ... 

why would an attacker need to find a 0-day bug when he can just sit back and
watch as the kernel suppliers struggle with backporting covered up security
fixes and pick up the ones they missed? unless you want to claim that attackers
are worse at identifying said silent fixes than kernel suppliers but i hope you
realize how ridiculous that would be.

> I.e. our opinion is, on very good and honest grounds,

'good' and 'honest' are not exactly the words i'd use here ;)

> that your scheme creates a false sense of security and actually harms
> real security and we simply refuse to support such a scheme. 

false sense of security is a term that you should understand before you use it
in context. in particular, you didn't demonstrate the origin of any sense of
security, never mind a false one. second, you didn't demonstrate any harm from
properly disclosing security fixes (vs. covering them up).

