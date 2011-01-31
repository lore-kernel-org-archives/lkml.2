Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1AaKPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:15:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaKPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eB+/O0ei6mZVPi52P1tYo3D9vf4ZaiN8D77uwtitDmaPussveRhVP/4nmc2TfoxQVh
         AbFoUoOvXcWrBdaGO7uYGjmpLoMUwAwCc/Smuy143w9uqgCDIy0ScumlyEhQwNOUluL9
         PlLC3CRMmTRqWFhKPcLOej5owKpLFdxiIEFdE=
MIME-Version: 1.0
In-Reply-To: <1296461958.4168.5.camel@dell>
References: <1295440968.2276.46.camel@dell>
	<ih8qf2$41t$3@dough.gmane.org>
	<4D380279.4070502@suse.cz>
	<1295594371.27658.3.camel@dell>
	<20110121101755.GP16804@shadowen.org>
	<1296461958.4168.5.camel@dell>
Date: Mon, 31 Jan 2011 12:15:10 +0200
Message-ID: <AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
Subject: Re: Checkpatch problem with Kconfig help symbol ?
From: Tomas Winkler <tomasw@gmail.com>
To: tapio.vihuri@nokia.com
Cc: ext Andy Whitcroft <apw@canonical.com>, ext Michal Marek <mmarek@suse.cz>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:19 AM, Tapio Vihuri <tapio.vihuri@nokia.com> wrote:
> On Fri, 2011-01-21 at 10:17 +0000, ext Andy Whitcroft wrote:
>> On Fri, Jan 21, 2011 at 09:19:31AM +0200, Tapio Vihuri wrote:
>> > On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
>> > > On 20.1.2011 09:06, WANG Cong wrote:
>> > > > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
>> > > >
>> > > >> Hi
>> > > >>
>> > > >> Is this false positive ?
>> > > >>
>> > > >> WARNING: please write a paragraph that describes the config symbol fully
>> > > >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
>> > > >>
>> > > >>
>> > > >> Interesting enough, also:
>> > > >>
>> > > >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
>> > > >> please write a paragraph that describes the config symbol fully #430:
>> > > >> FILE: input/misc/Kconfig:430:
>> > > >> +       help
>> > > >>
>> > > >>
>> > > >> But this is different line.
>> > > >>
>> > > >
>> > > > Seems yes, the Kconfig part of your patch looks fine.
>> > >
>> > > The check is complaining that the help text is too short:
>> > >
>> > > +config ECI_CTRL_DEBUG
>> > > + bool "ECI controller debug"
>> > > + depends on INPUT_ECI_AT20
>> > > + help
>> > > +   Say Y here to enable debugging messages for ECI controller driver.
>> > >
>> > > Michal
>> >
>> > Hi.
>> >
>> > That I suspect, and I tried to add four lines more.
>> > But it still complain the same.
>>
>> If you have a patch which has four or more lines and trips this message
>> it is false yes.  Please do send me your example, as my current tests
>> pass.
>>
>> -apw
>
> Hi.
>
> Sorry for the delay, I had made stupid email filter. Mea Culpa.
>
> It's working OK. If there is only three lines of help, checkpatch will
> complain.
> With four lines, it's not.
>
> I add more help in my case. It toggle driver debug on/off, so I try
> harder to figure out how to say it with more words ;)
>
> BR,
> Tapio
>

I believe that the warning is not descriptive enough, I also had to
look into the checkpatch script to
figure out what is going on.
What about adding little explanation like that:

WARNING: please write a paragraph that describes the config symbol
fully (4 lines at least)

Thanks
Tomas
