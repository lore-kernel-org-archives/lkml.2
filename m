Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0FUFab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:30:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42304 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0FUFa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JjZqfrpKIGTiSto714HIo3sHlcQYZD3wdjbRhR51s/JfOtCO2p0VebURU3Eze75zoO
         Wz3HNsuCLD+aawfOPdnyPRx/q+JVuifkdRNTWAZLUWD2TJocIncandiKAN7OzPUjo4o8
         oEmwFsPX6MtQy8LTyHZ1UsD5y1Qsw7LXHufpM=
MIME-Version: 1.0
In-Reply-To: <4C1EBE06.7020605@seas.upenn.edu>
References: <AANLkTinq_3P-QrTqsEdtyMbBtc9EXhahclER_4s5_Kx2@mail.gmail.com>
	<AANLkTikExwM_LBUw_-z2eimO96Dxs_fNfAM4jlftXyHM@mail.gmail.com>
	<4C1E6A8C.4020904@seas.upenn.edu>
	<AANLkTimCsVwppeTKXErpA6_1vwPHuQeqJHcdzLKd2EEp@mail.gmail.com>
	<4C1EBE06.7020605@seas.upenn.edu>
Date: Sun, 20 Jun 2010 22:30:26 -0700
Message-ID: <AANLkTikR0PXLqYuK8jDd_pWvcmVlRLnQFLVElHH8e71a@mail.gmail.com>
Subject: Re: Wacom based devices and the mt kernel protocol.
From: Ping Cheng <pinglinux@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>,
       Chase Douglas <chase.douglas@canonical.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 6:19 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>
>>>>> This impact very much the decision of a Linux user wanting to buy wacom mt device.
>>>>
>>>> I think end users have already got the Linux support from Wacom.  Can
>>>> you share the specific issues that are preventing Linux end users from
>>>> buying a Wacom MT devices? If I didn't misunderstand your point here,
>>>> you are talking about Linux users, not Linux developers/hackers,
>>>> right?
>>>
>>> I think normal users wanting to use linux for MT are generally frustrated and
>>> confused at the moment.
>>
>> Why do the end users get frustrated and confused? Can you share some
>> examples from an end user's (not developer's) perspective with me?
>
> Sorry, I've been too focused on the n-trig users.  They have been frustrated,
> and I've seen from the forums that some have been playing with customized
> versions of both the kernel and wacom x driver to get your two finger gestures.
>
> I'm also projecting my own frustrations, seeing the X mt interface still not
> quite set, and very little in the way of applications that use mt at all.
> We're still quite a ways away from seeing the full potential of a more hands on desktop.

As far as I understand,  this issue is not device driver or MT support
specific. It is universal  on Linux.

>>> Certainly the protocol between the wacom kernel driver
>>> and the wacom user space driver is way below the level that most are following.
>>
>> By "most", do you mean most MT device drivers, or most end users, or
>> most developers? I am eager to bring the Wacom driver to the specific
>> level.
>
> End users, they don't tend to care about the internal protocols as long as their
> programs do what they want.

Then, I still don't get what you meant by "way below the level that
most are following". I'd really like to understand it so I can work on
it.

Thank you,

Ping
