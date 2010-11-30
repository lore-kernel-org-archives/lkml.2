Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0K3Bjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:39:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1997 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab0K3Bjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:39:47 -0500
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
From: Joe Perches <joe@perches.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: peter@stuge.se, ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CF42C17.2070500@openwrt.org>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se>  <4CF42C17.2070500@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 17:39:45 -0800
Message-ID: <1291081185.16349.133.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 23:41 +0100, Felix Fietkau wrote:
> On 2010-11-29 7:07 AM, Peter Stuge wrote:
> > Luis R. Rodriguez wrote:
> >> On Sun, Nov 28, 2010 at 3:53 PM, Joe Perches <joe@perches.com> wrote:
> >> > Make the function name match the function purpose.
> >> > ath_debug is a debug only facility.
> >> > ath_print seems too generic a name for a debug only use.
> >> Nack, I don't see the point.
> > 
> > The point is to improve readability. I like the patch.
> And how exactly does this improve readability? Don't get me wrong, I
> generally like to see more cleanups merged to the ath/ath9k drivers
> (they do need it, after all).

It's considered polite to cc the patch author.

print is generic, debug is specific.
This function has a specific use for debugging
not a generic use all for logging.

If it was ath_print(level, etc) with KERN_<level>
passed as the first argument that'd be similar
to other kernel calls.  As is, it's not.

> But in my opinion, simple renaming churn like this does nothing but
> annoy people who want to get other work done at the same time.

This sort of thing can be done when other changes have
just been merged to minimize conflicts.

> Consider the large number of lines touched (and the potential merge
> conflicts with other code because of that), relative to the microscopic
> aesthetic gain (if any).
> 
> Instead I'd like to see more cleanups that go beyond trivial function
> renames.

I gauge my willingness to spend time on subsystems on
the maintainers willingness to merge things that improve
readability and correctness.

cheers, Joe

