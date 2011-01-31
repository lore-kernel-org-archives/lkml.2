Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1AaXBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:01:10 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60643 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab1AaXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:01:07 -0500
Date: Mon, 31 Jan 2011 16:01:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Thomas Chou <thomas@wytron.com.tw>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] i2c-gpio: add devicetree support
Message-ID: <20110131230100.GE27856@angua.secretlab.ca>
References: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw>
 <AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com>
 <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
 <AANLkTini7Hx6dbTAKJKJy=NnC+LFcQuHEsayxwJJ78-+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTini7Hx6dbTAKJKJy=NnC+LFcQuHEsayxwJJ78-+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 02:35:31PM -0800, Håvard Skinnemoen wrote:
> Hi,
> 
> On Mon, Jan 31, 2011 at 12:09 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
> > On Sun, Jan 30, 2011 at 8:26 PM, Håvard Skinnemoen
> > <hskinnemoen@gmail.com> wrote:
> >> Hi,
> >>
> >> On Sun, Jan 30, 2011 at 7:56 AM, Thomas Chou <thomas@wytron.com.tw> wrote:
> >>> From: Albert Herranz <albert_herranz@yahoo.es>
> >>>
> >>> This patch is based on an earlier patch from Albert Herranz,
> >>> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
> >>> 9854eb78607c641ab5ae85bcbe3c9d14ac113733
> >>
> >> That commit has a single-line description of which I don't understand
> >> a single word (unless "wii" is what I think it is, which seems
> >> likely). Could you please explain how that commit relates to this
> >> patch?
> >
> > The URL got wrapped.  Try this one (assuming my mailer doesn't wrap it):
> >
> > http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/9854eb78607c641ab5ae85bcbe3c9d14ac113733
> 
> Ok, that seems to be a _bit_ more related, but not that much. I'd
> really prefer a patch description which can stand on its own.
> 
[...]
>
> >> Not saying that it necessarily _is_ a terrible idea, but I think the
> >> reasoning behind it needs to be included in the patch description.
> >
> > Nah, he doesn't really need to defend this since it is a well
> > established pattern.  device tree support is in core code now (see
> > of_node an of_match_table in include/linux/device.h), and other
> > drivers do exactly this.
> 
> Well, perhaps you're right, but I still think the patch description is
> a bit on the thin side. In particular, terms like "as Grant suggested"
> isn't very helpful for people like me who don't know what you
> suggested (even though I'm sure it was a good suggestion).
> 
> I think the patch lacks a good description of what's being changed and
> why. The references may be nice to have as a supplement to that, but
> describing things entirely in terms of some unknown e-mail discussion
> that happened earlier is not very helpful for people who want to
> figure out what's going on a couple of months or years from now.

No arguments from me on those points.

g.
