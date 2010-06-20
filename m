Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0FTTaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 15:30:20 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:50199 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab0FTTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 15:30:15 -0400
Message-ID: <4C1E6A8C.4020904@seas.upenn.edu>
Date: Sun, 20 Jun 2010 15:22:52 -0400
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
References: <AANLkTinq_3P-QrTqsEdtyMbBtc9EXhahclER_4s5_Kx2@mail.gmail.com> <AANLkTikExwM_LBUw_-z2eimO96Dxs_fNfAM4jlftXyHM@mail.gmail.com>
In-Reply-To: <AANLkTikExwM_LBUw_-z2eimO96Dxs_fNfAM4jlftXyHM@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/20/10 01:35, Ping Cheng wrote:
> Hi Mohamed,
> 
> I am glad that you've initiated this email thread. Otherwise, I would
> have to find a proper way to explain the current status of Wacom MT
> support. Please see my comments inline.
> 
> Thank you,
> 
> Ping
> 
> On Fri, Jun 18, 2010 at 4:20 AM, Mohamed Ikbel Boulabiar
> <boulabiar@gmail.com> wrote:
>> Hi,
>>
>> Now we can find many multitouch devices based on wacom Wacom panel/digitizer
>> Bamboo Pen&Touch, HP tm2, Fujitsu LifeBook T4410 & T4310, etc...
>>
>> it seems that these devices are supported in some way in Linux Kernel,
>> but I want to know if they are compliant with the MT Linux protocol.
> 
> As most of you know, the current Wacom two finger touch devices have
> been supported on Linux since last Oct.  However, they are not
> supported with the current in-kernel MT protocol, aka, MT type A
> protocol.
> 
> I know you would ask me why. The reason is simple: it doesn't support
> the Wacom case - finger tracking.  If you wonder why I don't work with
> the other developers to support Wacom MT case, I can assure you that I
> am working with them. We will support Wacom MT devices once the
> appropriate protocol is available.

Er, the A protocol supports both tracked and untracked fingers (just wouldn't
mix the two for a single device).  Still, you probably have a point about
waiting for the B protocol to make its way upstream.


>> N-Trig based devices and Stantum ones are the most compliant,
> 
> That's fair since they don't need to track the fingers.

N-Trig doesn't have hardware tracking, Stantum does.

>> so Wacom situation needs to be clarified specially considering they are HID
>> devices (meaning similar to the others devices which respect the
>> protocol).
> 
> Well, it is not a pure HID issue.  It is more of how we want to
> support MT on Linux issue.

Side note for Ikbel, its not clear the wacom devices actually stay HID compliant
when the full protocol is active, and the basic modes are really basic (and not
very useful).  As my understanding of the way HID and usb stuff communicate in
general, I've been growing less convinced its a protocol issue, more like an
initialization problem.  Still I'm not quite sure.

>> This impact very much the decision of a Linux user wanting to buy wacom mt device.
> 
> I think end users have already got the Linux support from Wacom.  Can
> you share the specific issues that are preventing Linux end users from
> buying a Wacom MT devices? If I didn't misunderstand your point here,
> you are talking about Linux users, not Linux developers/hackers,
> right?

I think normal users wanting to use linux for MT are generally frustrated and
confused at the moment.  Certainly the protocol between the wacom kernel driver
and the wacom user space driver is way below the level that most are following.

As developers, I think we have a strong interest in seeing wacom migrate to a
shared protocol.  But our interests are in pushing the functionality beyond
what's currently available, and we just want to see everyone get equal access to
features as we create them.  I think to convince Ping (if he weren't already),
and the others working on the Wacom code, we'd have to show off some of what
he's going to gain by switching, and at the moment, as a community, I don't
think we are quite ready, maybe soon.

So, Ping, consider that I and others will have cool things to show you in the
near future, and if you start migrating you will get some cool new functionality
when the two waves of progress collide.  Also, I think Henrik's B protocol has
some cool advantages which you've demonstrated considerable interest in.  So I
gather you do intend to switch when its convenient?

>> Ping can you clarifie the situation of wacom based devices ?
> 
> What else do you need me to clarify? I am all ears and I am ready to
> clarify any thing that puzzles you.

Will Wacom be moving to more than 2 finger support in the near future?  Do you
already have some products on the market?

Rafi

> Ping
> 
>> Thanks,
>>
>> ik.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkweaooACgkQwuRiAT9o609XfACeN7OgUTXusOztPHwoHbTEqF7F
VwwAoKIedssO79JIzeOnkegjsBu2fLkl
=QyOK
-----END PGP SIGNATURE-----
