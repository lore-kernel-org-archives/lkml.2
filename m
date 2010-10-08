Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0JHWC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:02:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48266 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab0JHWCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sCwUs+8V4LqBOw68+IaWPyETxmcO2LTZmdmTn+X7/c5mNf7qFPGlABo0fZa47k+dEZ
         6NPuDAVsK5TUhFV42YXOrIyZvxWXVq2msss8N4cgpWua4gZSWgiJCUX3m/LCt0DjIH+D
         9EO1Yqp8E05XMEJvW6yNr29mrIFoht99bQdO4=
MIME-Version: 1.0
In-Reply-To: <1286567442.4153.343.camel@m0nster>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk> <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk> <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
 <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com> <20101008091331.74871a42@lxorguk.ukuu.org.uk>
 <1286551434.4153.21.camel@m0nster> <20101008175636.766dd1f5@lxorguk.ukuu.org.uk>
 <1286556328.4153.142.camel@m0nster> <AANLkTikc8X0nz1cCxgfbaqLzCMiBLogLeU0ZdFoGEpP6@mail.gmail.com>
 <1286564491.4153.284.camel@m0nster> <AANLkTim5E5WwD64RJ7NAk6Zr9NZ6jstrKSmjRTL039VR@mail.gmail.com>
 <1286567442.4153.343.camel@m0nster>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 8 Oct 2010 18:02:33 -0400
X-Google-Sender-Auth: uMQBbUQ1uTyMy-l_6ULZ8VEAVvE
Message-ID: <AANLkTik6tNhKq5yTh5_qaY9JdOTPSTH1CzG+3B+qnb=N@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 15:50, Daniel Walker wrote:
> On Fri, 2010-10-08 at 15:20 -0400, Mike Frysinger wrote:
>> On Fri, Oct 8, 2010 at 15:01, Daniel Walker wrote:
>> > On Fri, 2010-10-08 at 14:38 -0400, Mike Frysinger wrote:
>> >> On Fri, Oct 8, 2010 at 12:45, Daniel Walker wrote:
>> >> > On Fri, 2010-10-08 at 17:56 +0100, Alan Cox wrote:
>> >> >> > I don't think the kernel is going to implode if we allow an optional
>> >> >> > ttyS override for debugging purposes.. I just don't see that "screwing"
>> >> >> > up the kernel.
>> >> >>
>> >> >> That is perhaps why you are not a subsystem maintainer.
>> >> >
>> >> > No, I'm sure it's not.
>> >> >
>> >> > What I was telling Greg is that this type of override is allowed right
>> >> > now, if you mod the source (everything is allowed if you mod the source
>> >> > right?) ..
>> >>
>> >> just because someone can mod the source code to add a root shell
>> >> doesnt mean we should accept patches to do it
>> >
>> > That's not what I was getting at. If you can mod the source to add the
>> > override, then adding in a patch which also requires you to mod the
>> > source to add the override should be acceptable because it's no
>> > different that what we currently have.
>>
>> sorry, but you lost me.  all i see is "drop the hack code".
>
> I can make it simpler for you. You add code into Linux, people can
> modify it, and you can't control that.

while true, that lacks justification for merging hacks into mainline
-mike
