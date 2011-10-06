Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654Ab1JFAuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:50:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42719 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935275Ab1JFAuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MURyco+nmv5MeY_2jK-8A-628MHJMe+gt5VsXVT+JtgUA@mail.gmail.com>
References: <201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb>
	<20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<20111004223932.GA3460@localhost.pp.htv.fi>
	<CACqU3MWr5DKAWKydHmJuz=+a3UN3KdtsdXwfE-UxSD5_9tzqag@mail.gmail.com>
	<20111005201904.GC14406@localhost.pp.htv.fi>
	<CACqU3MVUO8WP6Q=QEX+2GosprB0JvCawu2iNpptcsscYr_DcvA@mail.gmail.com>
	<20111005235541.GA4328@suse.de>
	<CACqU3MURyco+nmv5MeY_2jK-8A-628MHJMe+gt5VsXVT+JtgUA@mail.gmail.com>
Date: Wed, 5 Oct 2011 20:50:08 -0400
Message-ID: <CACqU3MVd8z05_x8HWKyeXn8fVp0NZkNGYh5ZMu0BPJyo4Bqj=A@mail.gmail.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 5, 2011 at 8:23 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Wed, Oct 5, 2011 at 7:55 PM, Greg KH <gregkh@suse.de> wrote:
>> On Wed, Oct 05, 2011 at 04:36:50PM -0400, Arnaud Lacombe wrote:
>>> Hi,
>>>
>>> On Wed, Oct 5, 2011 at 4:19 PM, Adrian Bunk <bunk@stusta.de> wrote:
>>> > On Wed, Oct 05, 2011 at 04:00:39PM -0400, Arnaud Lacombe wrote:
>>> >> Hi,
>>> >>
>>> >> On Tue, Oct 4, 2011 at 6:39 PM, Adrian Bunk <bunk@stusta.de> wrote:
>>> >>...
>>> >> > Each time a patch goes through him into the kernel, he certifies that
>>> >> > his real name is Andrew Morton.
>>> >> >
>>> >> > If that would not be his real name, it would make him somewhere between
>>> >> > completely untrustable and punishable at court.
>>> >> >
>>> >> Under which jurisdiction ? Under which law ?
>>> >>
>>> >> IANAL, but US copyright law does recognize the use of pseudonym for
>>> >> copyrighted work[0], without requirements to disclose one's legal
>>> >> name.
>>> >
>>> > I am not talking about copyright law.
>>> >
>>> > When you add a Signed-off-by: to a patch you have to use your real name
>>> > (see Documentation/SubmittingPatches for details).
>>> >
>>> > If violating that would be considered fraud or some other crime in some
>>> > jurisdictions is likely a non-trivial question.
>>> >
>>> One might still question the legality/constitutionality of such a
>>> statement. AFAIK, Greg KH, author of the sentence (in af45f32d25c) is
>>> not a lawyer.
>>
>> How do you not know that such a sentance was not vetted by a lawyer?  :)
>>
> I assume the worst case, unless given documents proving otherwise. The
> commit message is not particularly verbose.
>
Just thinking about it, but even if lawyers have been involved, this
has been done, unless error of my part, behind closed doors, without
any public records, so I'd tempted to ask "who paid those lawyers?",
"what was the qualification of those lawyers?", "what was the interest
of those lawyers?" and "what was the interest of those who paid the
lawyers?".

Moreover, the commit message's subject states "We can not allow
anonymous contributions to the kernel", however it fails to describe
who's behind "we".

Finally, I'd be tempted to make a difference between "Anonymous" and
"Pseudonymous".

regards,
 - Arnaud
