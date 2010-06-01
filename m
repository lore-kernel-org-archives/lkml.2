Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0FAOMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:12:22 -0400
Received: from webmail01.domeneshop.no ([194.63.248.8]:37722 "EHLO
	webmail01.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab0FAOMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:12:20 -0400
Content-Disposition: inline
Content-Transfer-Encoding: binary
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MIME::Lite 3.01 (F2.74; T1.18; A1.74; B3.07; Q3.07)
From: uwaysi.bin.kareem@paradoxuncreated.com
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Psychovisually-optimized HZ setting (2.6.33.3)
Date: Tue, 01 Jun 2010 16:12:17 +0200
X-Remote-Address: 91.186.70.220
X-User-Agent: Opera/9.63 (Windows NT 5.1; U; en) Presto/2.1.1
X-Mailer: Domeneshop webmail 1.07 (2008-04-23)
X-Moam-Version: 0.93
Message-Id: <E1OJSCX-0000ke-Da@webmail01.domeneshop.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I guess I could pick this post apart, just for the fun of it. I really hate satanical stupidity. Most of you here, can probably follow a level, where my arguments make sense, and some of you can even follow the religious argument. However a few may post completely retarded stuff like this. Now I'm going to pick this apart, so that you can rather imagine this being done, in similar future incidents, however I will just ignore. My life is better without this kind of conversation ;)

On Tue, 01 Jun 2010 15:25:46 +0200, <Valdis.Kletnieks@vt.edu> wrote:

> On Tue, 01 Jun 2010 12:47:15 +0200,  
> uwaysi.bin.kareem@paradoxuncreated.com said:
>
>> I do not really have any numbers Valdis, other than simple glxgears  
>> benchmarks.
>
> I suspect that glxgears isn't telling you what you think it's telling  
> you.
> For starters, the distinction between a glxgears wank-o-meter reading of
> 4,000 FPS and 8,000 FPS doesn't actually *matter* when your screen is  
> only
It matters to jitter measurements, where numbers in the 80000 region, is giving me the information I need. With more complex scenes, who would only render say 100fps, less information would be given. We are not talking about how complex scenes, we can render. We are talking about jitter, which is present, regardless of scene-complexity.
> actually able to do 60 or 72 or 120FPS.  What it *really* tells you is  
> that
> the card that can do 8,000FPS can probably handle a more complicated  
> scene
> before the FPS drops below the refresh rate and you miss a frame, which
> *will* be noticeable.
>
> Repeat after me: Graphics cards are locked to the refresh rate, and you  
> can't
I think very few things should be repeated after you. First the 8000fps, and now you claim vsynced behaviour. This is a contradiction.
> see jitter or low frame rates unless it causes tearing, missed frames, or
> other screen artifacts.  And to maximize your chances of not missing a  
> screen
> update, you want a *lower* HZ value so you don't waste precious time  
No. You run 50hz, I run 3956hz. If you have this amount of garbage in your head, maybe it's in your vision aswell, and little can help you.
> handling
> timer interrupts.
>
>> However I have a lot of experience with jitter, and I am looking for  
>> sporadic
>> jitter, jitter related to application-startup, jitter that is more or  
>> less
>> constant.
>
> "Constant jitter" - talking like that will get you mocked mercilessly by
> some people.

Mindless people, who set a value of 4000hz instead of 3956, because they don't believe or lack the skill, to tune a value. Instead the value 4000 would reflect a guess, not tuned for the human senses, and we are back to the old stoopid computer again, tuned by people like Vladis, who would rather sit and run 50hz updates in machocistic hope of saving a cpu cycle, when reallife tests show that even values of 10000hz make little difference of performance in opengl. You do that Vladis. Live with the cheapest clothes, the most outwatered drinks, and the stalest and cheapest bread. And for us, who appreciate higher intelligence, and use the resources available to us, we will enjoy ourselves a little, away from backwardpeople like you.

>> Ofcourse I do not need any numbers either. If you think 1000 is better  
>> than
>> 50, then there is a difference between 1000 and 4000 aswell.
>
> OK, so why not go straight to 8,00 or 10,000 instead? Did you try values  
> in that
> range?
>
> Hate to tell you this, but around here, you *do* need numbers to justify
> making changes.  It used to be that HZ=100 was the only choice - 250 and
In a menu. Lol, some of us actually looked at the source, and changed that value anyway. It's really quite simple, and if you don't posess even that basic level of skill, what are you doing on LKML. Lol, it's never been 100hz or no choice. You seem to even lack the most basic insight into what opensource is.
> 1000 were added because somebody showed that those options made  
> noticeable
> differences in the latency/overhead tradeoff (interestingly enough,  
> HZ=1000
> mattered more to audio processing than video, because most video cards  
> are
> locked to a relatively low refresh rate while audio cards will produce
> a noticable transient if you miss a timeout by even 1ms).  HZ=300 was  
> added
> specifically to play nice with 60-hz video processing.
Play nice? Jitter between frames are still a problem, even though 300hz is divisible by 60.
>
> But to swallow the added overhead of setting HZ=4000, you'll have to show
> some remarkable benefits (especially when you're pulling out a magic  
> number
> like 3956 rather than 4000).

You completely failed to comprehend the simple statement in my previous post "There is no performance penalty for opengl applications". How is it possible?

>> Put it simply one might state "If you feel that your computer is a bit
>> stoopid, try increasing the value, and maybe you will be more  
>> satisfied." This
>> because the computer now, is more like the human senses.
>
> And maybe you won't be, unless you're the type of person who buys the
> special $1,000 HDMI cables and $600 wooden volume controls.   
> Unfortunately,
> we aren't building kernels for those type of people.

We? This is opensource. I do whatever I will with the kernel. You take your cheap pirate rip-off copy of a volume control, and I WILL have the nice volume control. Resources exist to be consumed.

>> And for those who would like to understand some of the methology behind  
>> this,
>> again www.paradoxuncreated.com .Try the meditation-techinque, which  
>> purifies
>> the mind from spirits.
>
> Unfortunately, that's unlikely to get your changes into the kernel.

If people like you are influental in what goes into the kernel, the linux community truly suffers. Be ready for the cheapest and the lowest, just because theoretically some cpu cycles get lost. Why don't you get yourself and z80 and live in sinclair lands, it truly sounds like you want to keep being there.

>> Any answers related to this post, critisising or wasting my time, will  
>> be ignored.
>
> Nor is this likely to help...

I don't think you have any idea about what helps and not helps. Go to a 1$ mental hospital, with zx sinclair computers, and run it at 0.0001hz screen update. That will surely save cpu cycles.

On the other hand it would bring our economy to a halt, and development of linux or any other OS, would be for a stagnant hardware market. What should we do with the new hardware? Pile em up, and brag, and never use em, because it saves cpu cycles?
Like a pile of trash?
Might aswell go the direct route to the trashheap then.

Peace Be With You.
Uwaysi. (in a more-than-rare-flamewars thesedays)

PS: To all the sane people here, do it. You will enjoy it. Do not be mr. 50hz sadomachochist.
