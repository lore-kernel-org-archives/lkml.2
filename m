Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0FUB0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:26:15 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:50721 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab0FUB0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:26:12 -0400
Message-ID: <4C1EBE06.7020605@seas.upenn.edu>
Date: Sun, 20 Jun 2010 21:19:02 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>,
       Chase Douglas <chase.douglas@canonical.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Wacom based devices and the mt kernel protocol.
References: <AANLkTinq_3P-QrTqsEdtyMbBtc9EXhahclER_4s5_Kx2@mail.gmail.com>	<AANLkTikExwM_LBUw_-z2eimO96Dxs_fNfAM4jlftXyHM@mail.gmail.com>	<4C1E6A8C.4020904@seas.upenn.edu> <AANLkTimCsVwppeTKXErpA6_1vwPHuQeqJHcdzLKd2EEp@mail.gmail.com>
In-Reply-To: <AANLkTimCsVwppeTKXErpA6_1vwPHuQeqJHcdzLKd2EEp@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/20/10 20:31, Ping Cheng wrote:
> On Sun, Jun 20, 2010 at 12:22 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>>> N-Trig based devices and Stantum ones are the most compliant,
>>>
>>> That's fair since they don't need to track the fingers.
>>
>> N-Trig doesn't have hardware tracking, Stantum does.
> 
> Sorry for my ignorance. I don't have much time to keep track of what
> other devices are doing. Keeping all of my own balls rolling is more
> than enough work for me :).
> 
>>>> so Wacom situation needs to be clarified specially considering they are HID
>>>> devices (meaning similar to the others devices which respect the
>>>> protocol).
>>>
>>> Well, it is not a pure HID issue.  It is more of how we want to
>>> support MT on Linux issue.
>>
>> Side note for Ikbel, its not clear the wacom devices actually stay HID compliant
>> when the full protocol is active, and the basic modes are really basic (and not
>> very useful). As my understanding of the way HID and usb stuff communicate in
>> general, I've been growing less convinced its a protocol issue, more like an
>> initialization problem.
> 
> Thank you Rafi for explaining this issue.  Wacom tablets have a
> relatively long history, longer than the time that digitizers were
> supported on Linux. The default HID mouse protocol was introduced due
> to the history, which was required by Microsoft.... We can not change
> history, can we :)?
> 
> Wacom kept their devices consistent protocol-wise over the years.
> That's why even the modern digitizers default to the basic HID
> protocol.
> 
>> Still I'm not quite sure.
> 
> I think you've got the point.
> 
>>>> This impact very much the decision of a Linux user wanting to buy wacom mt device.
>>>
>>> I think end users have already got the Linux support from Wacom.  Can
>>> you share the specific issues that are preventing Linux end users from
>>> buying a Wacom MT devices? If I didn't misunderstand your point here,
>>> you are talking about Linux users, not Linux developers/hackers,
>>> right?
>>
>> I think normal users wanting to use linux for MT are generally frustrated and
>> confused at the moment.
> 
> Why do the end users get frustrated and confused? Can you share some
> examples from an end user's (not developer's) perspective with me?

Sorry, I've been too focused on the n-trig users.  They have been frustrated,
and I've seen from the forums that some have been playing with customized
versions of both the kernel and wacom x driver to get your two finger gestures.

I'm also projecting my own frustrations, seeing the X mt interface still not
quite set, and very little in the way of applications that use mt at all.  We're
still quite a ways away from seeing the full potential of a more hands on desktop.

>> Certainly the protocol between the wacom kernel driver
>> and the wacom user space driver is way below the level that most are following.
> 
> By "most", do you mean most MT device drivers, or most end users, or
> most developers? I am eager to bring the Wacom driver to the specific
> level.

End users, they don't tend to care about the internal protocols as long as their
programs do what they want.

>> As developers, I think we have a strong interest in seeing wacom migrate to a
>> shared protocol.  But our interests are in pushing the functionality beyond
>> what's currently available, and we just want to see everyone get equal access to
>> features as we create them.  I think to convince Ping (if he weren't already),
>> and the others working on the Wacom code, we'd have to show off some of what
>> he's going to gain by switching, and at the moment, as a community, I don't
>> think we are quite ready, maybe soon.
> 
> I do see the positive sign here. And, BTW, it is a she that you are
> talking to :).  Don't worry, you are still taking to the same person.
> So, it really doesn't matter to me. But, I don't want you to get the
> fact from someone else and to be "puzzled" :).

Um, what can I say, the hazards of interacting with just text in a language
curiously lacking in proper androgynous pronouns.  Please forgive my ignorance
particularly culturally.

>> So, Ping, consider that I and others will have cool things to show you in the
>> near future, and if you start migrating you will get some cool new functionality
>> when the two waves of progress collide.  Also, I think Henrik's B protocol has
>> some cool advantages which you've demonstrated considerable interest in.  So I
>> gather you do intend to switch when its convenient?
> 
> Why not? Do you think I am that stupid :)? To be honest, I've been
> waiting for the day for a while.

Not at all, I'm just incompetent at subtle nudging.

>>>> Ping can you clarifie the situation of wacom based devices ?
>>>
>>> What else do you need me to clarify? I am all ears and I am ready to
>>> clarify any thing that puzzles you.
>>
>> Will Wacom be moving to more than 2 finger support in the near future?  Do you
>> already have some products on the market?
> 
> No, we do not have 2+ finger devices on the market and I can not tell
> what the future would be. We'll see what it is when time comes.  Any
> more questions :)?

Nope, I think I've put my foot in it enough for the evening :-)

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkwevgQACgkQwuRiAT9o60+k9QCdEPogsLgVUDc7K/vqWNvjd/yS
IYwAoPyS0hOuqS51Dlft011EInnrx7+J
=mPjC
-----END PGP SIGNATURE-----
