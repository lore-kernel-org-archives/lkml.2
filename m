Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0JHCEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 22:04:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58049 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0JHCEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 22:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=AATdrAEtIUo0zCxv3J8WI61SI9DLXhZ7ah62I/coduIa/dORA20YC9YIQh5l/25aoz
         vq12LLbYhEX4XTpB4OmUq0sPmzg5gLta8iPjmQREooXE+7+d/S28eq0hotpBT3toHKwu
         Sx37X7oA8yKwMYUOU1I+OFq3joYALwQr3dMK0=
MIME-Version: 1.0
In-Reply-To: <1286489490.23836.121.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk> <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk> <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
 <20101007211513.GB26660@suse.de> <1286488038.23836.101.camel@c-dwalke-linux.qualcomm.com>
 <20101007215221.GA11478@suse.de> <1286489490.23836.121.camel@c-dwalke-linux.qualcomm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 22:04:12 -0400
X-Google-Sender-Auth: tc7fEEm-5hKOVrnO4kV_pHcfN2k
Message-ID: <AANLkTi=0V=PZDuPnjbHR8Bt5+j==uwhms3nULNS67Syt@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 18:11, Daniel Walker wrote:
> On Thu, 2010-10-07 at 14:52 -0700, Greg KH wrote:
>> On Thu, Oct 07, 2010 at 02:47:18PM -0700, Daniel Walker wrote:
>> > On Thu, 2010-10-07 at 14:15 -0700, Greg KH wrote:
>> > > On Thu, Oct 07, 2010 at 01:51:18PM -0700, Daniel Walker wrote:
>> > > > > We've said no over a period of about ten years to a lot of attempts to
>> > > > > just borrow the ttyS0 range. If we'd said yes it would have been a
>> > > > > complete mess by now.
>> > > > >
>> > > > > So the answer is no.
>> > > >
>> > > > Nothing can be unilateral, there's always room for exceptions. You
>> > > > should say something more like "it's possible, but unlikely".
>> > >
>> > > Hm, how about this, as the TTY and serial driver[1] maintainer, I will
>> > > not accept this kind of patch at all.
>> > >
>> > > Is that final enough for you?
>> >
>> > So you don't like it, that's fair enough .. <thinks>I wonder what other
>> > maintainers I can send this too</thinks> ;)
>> >
>> > Can you be more specific about your objections
>>
>> See everything that Mike and Alan wrote, do I need to repeat it?
>
> I'm not sure .. I would say "Yes" if I didn't get the feeling your
> already to tear my head off.
>
> I think the only disputed issue is the use of ttyS as options part of
> the driver ..

and using "serial_core" at all in favor of HVC or tty_core (the latter
might be easier for you as the former is a bit of unknown atm)
-mike
