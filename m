Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KJSaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:30:14 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40724 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KJSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:30:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121109115344.GB8078@arwen.pp.htv.fi>
References: <50929233.7030609@gmail.com> <50967BFD.6000308@gmail.com>
 <20121106112751.GD11931@arwen.pp.htv.fi> <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
 <20121108140649.GD19533@arwen.pp.htv.fi> <CAOUdcc_9UTZpdu6k7wyQc9Hjmv-0YgAGiwsm+NysEmS9VUxu+w@mail.gmail.com>
 <20121108193034.GB2962@arwen.pp.htv.fi> <CAOUdcc839T6xrVxX6YcFCs_X=PkyH=3GyLHs1s+pzgWz0faQtw@mail.gmail.com>
 <20121109115344.GB8078@arwen.pp.htv.fi>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Sat, 10 Nov 2012 19:29:49 +0100
X-Google-Sender-Auth: H2oc0v6U5_8-H6ioSubXL3ftPO0
Message-ID: <CAOUdcc__i38k8Xg4GXBViYq9pu+0imx17Y1eb98jaCoP_bvKGw@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 9, 2012 at 12:53 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Nov 09, 2012 at 10:31:47AM +0100, Dmytro Milinevskyy wrote:
>> Hi Felipe,
>>
>> On Thu, Nov 8, 2012 at 8:30 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Thu, Nov 08, 2012 at 08:07:57PM +0100, Dmytro Milinevskyy wrote:
>> >> > On Wed, Nov 07, 2012 at 02:14:00PM +0100, Dmytro Milinevskyy wrote:
>> >> >> Unfortunately I have some issues with git send-email.
>> >> >> I've attached the patch itself ..
>> >> >
>> >> > I'll apply it like that this time, but try to figure out how to send
>> >> > patches properly. We have some very helpful hints on
>> >> > Documentation/email-clients.txt which are hugely underused ;-)
>> >> >
>> >> well, I try to follow the rules as much as possible as long as tools
>> >> work ... =)
>> >
>> > git send-email has thousands of users and it works fine for them
>> > (including myself). Maybe you just misconfigured it ?!? ;-)
>> >
>> No, I was using it in the past w/o any issue.
>> In fact initial versions of the patch were sent exactly with git-send-email.
>>
>> However I lost my internet connection at home(some issues with ISP)
>> and at work place network environment somehow blocks
>> git-send-email(though thunderbird still can connect to the smtp server
>> ..).
>
> I don't think smtp server can make that distinction. Except for the
> message-id, there's nothing there which would help smtp server to figure
> out you're using git send-email. On top of that, it would be just extra
> work to maintain rules to block a tool which is essentially just sending
> an email.
>
> Make sure you're not missing some authentication with the mail server on
> your git send-email configuration.
>
> my 2 cents.

Thanks a lot, I very appreciate your help.
I even tried to use same laptop with same version of git I used to
send the patch for the first time but it didn't help.
Likely there's a network configuration that is blocking
git-send-email. I will try to figure it out with our system
administrators.

cheers,
-- dmytro

> --
> balbi
