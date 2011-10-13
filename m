Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1JMArL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:47:11 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45053 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751902Ab1JMArI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20111013001202.GB19446@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
 <20100907212915.GB6798@suse.de> <201009080254.03070.mihai.dontu@gmail.com>
 <20100908003424.GA27719@suse.de> <CAPs5rNZ07VZ0qK2PVG2u1DLEEnXS_CvVcYGLLE7fzFCcMo696A@mail.gmail.com>
 <20111013001202.GB19446@suse.de>
From: Aras Vaichas <arasv@magellan-technology.com>
Date: Thu, 13 Oct 2011 11:46:45 +1100
Message-ID: <CAPs5rNYJYauYSW4ByMVTn-sQSj=6i-1wmyX6MR_4BfYPGqQhWQ@mail.gmail.com>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
To: Greg KH <gregkh@suse.de>
Cc: "Mihai Don??u" <mihai.dontu@gmail.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 October 2011 11:12, Greg KH <gregkh@suse.de> wrote:
> On Thu, Oct 13, 2011 at 10:31:08AM +1100, Aras Vaichas wrote:
>> On 8 September 2010 10:34, Greg KH <gregkh@suse.de> wrote:
>
> You are responding to a message from over a year ago?

Yes, sorry, but it's the latest record I could find of this particular
bug and talk of the patch. I just wanted to see if it was followed up
or maybe there was some other issue that meant it couldn't be applied.


>> Did this patch get applied and the problem resolved?
>
> Probably, I'd suggest you take a look at the kernel sources to verify
> this, I can't remember what was applied last week very well, let alone
> last year.

Sorry, I should have checked there first.

It doesn't appear to have been applied to the version I use on my
product which is 2.6.33.7-at91-rt29.

The patch appears to have been applied to 3.1-rc4 so it happened
somewhere in between.

Oh well, I guess I was unlucky. Luckily this is only affecting 1
customer that I know of. Our previous kernel bug was the JFFS2 garbage
collection bug - that one was bricking our products in the field
randomly on every power cycle. I built a solid-state power-cycle jig
that switches our product on and off every few minutes to expose these
types of problems. :)


>> I'm running 2.6.33.7-rt29 and we have a customer in India who
>> complains that they can't connect via USB. We don't have the problem
>> here, or anywhere else that we know of.
>>
>> I looked at the logs of the device and it appears to have the same
>> Oops error as the one that this patch addresses.
>
> What kernel version are they using?  Hopefully something newer than the
> date of this original email :)

They are using our product, which is 2.6.33.7-at91-rt29.

Aras
