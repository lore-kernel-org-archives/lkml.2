Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab1HQRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:33:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1HQRdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:33:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=j935tw13fyQIlLZb8Fnp7i21ZuzwbR+76VuEVs29ZR2zYfRsaVPm8fMOmyyBWm/40
	uIqEDqG/ge2OUarwsqKPQ==
MIME-Version: 1.0
In-Reply-To: <20110817132114.GB10209@sirena.org.uk>
References: <20110815041524.GA7578@kroah.com>
	<CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
	<20110817045856.GB4936@kroah.com>
	<20110817132114.GB10209@sirena.org.uk>
Date: Wed, 17 Aug 2011 10:33:05 -0700
Message-ID: <CANqkERC2eyy3SQ6_vJncvuMdi=Yu=O8mZoXkggkX1q_4=d+q7g@mail.gmail.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Tim Bird <tbird20d@gmail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 6:21 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 16, 2011 at 09:58:56PM -0700, Greg KH wrote:
>> On Tue, Aug 16, 2011 at 04:01:57PM -0700, Tim Bird wrote:
>
>> > The other major out-of-tree patches we usually integrate are
>> > 1) Android
>
>> I would love to get some feedback/contacts with the Android teams to
>> talk about this with them.  If anyone knows anyone I should talk to
>> here, please let me know.
>
> Brian Swetland and Arve Hjønnevåg should be able to point you at the
> right people if they aren't themselves the right people.
>
> [Sorry if my software has mangled your name Arve]

(something ate the final 'g' (fixed above) but otherwise his name
seems to have survived)

As far as long-term kernels goes, from the Android perspective we
strongly prefer to snap up to the most recent released kernel on every
platform/device release.  I prefer to be as up to date on bugfixes and
features from mainline as possible and minimize the deltas on our
stack 'o patches as much as possible.

We've been getting more aggressive about merging in the -rc#s and then
rebasing on the final during development (before final stabilization
freeze for a release) in the last year or so, and it seems to work
pretty well.

Not all OEMs or silicon vendors are as comfortable with this approach
and I expect some would welcome a long term tree they can count on to
get critical fixes for, though.  Device release teams (even our own,
for lead devices we work on) are notoriously risk-averse (often for
good reasons), and tend to get really nervous when they see the total
change count or diff stat for pulling up to a new kernel release close
to "final rom" for a product.

Brian

(apologies to anyone who got this twice, gmail snafu with html
formatted email. I should use mutt for lkml...)
