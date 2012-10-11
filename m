Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab2JKSJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:09:04 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:49182 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2JKSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:09:02 -0400
From: Romain Francoise <romain@orebokech.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: Linux 2.6.32.60
Organization: orebokech dot com
References: <20121009094453.GA4289@1wt.eu>
	<87y5jeqv6b.fsf@silenus.orebokech.com> <20121011062916.GG8938@1wt.eu>
Date: Thu, 11 Oct 2012 20:09:00 +0200
In-Reply-To: <20121011062916.GG8938@1wt.eu> (Willy Tarreau's message of "Thu,
	11 Oct 2012 08:29:16 +0200")
Message-ID: <87vcegq3sz.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

Willy Tarreau <w@1wt.eu> writes:

> RDRAND certainly qualifies as a source of entropy and I judged it was
> appropriate for a backport for this reason. Nobody has objected about
> this during the review, but maybe you have a different opinion and valid
> reasons for these patches to be reverted ?
> [...]
> If you think these patches constitute a regression, I can revert them.
> However I'd like convincing arguments since they're here to help address
> a real issue.

I have no evidence of any problems caused by including these patches. It's
just that they don't match what I expect to find in a longterm release,
and *if* there are issues they will only show up on a limited set of
machines (Ivy Bridge or newer), so they will be more difficult to track
down.

But if you think that including the feature is worth the risk I'm totally
fine with it, it's your call to make anyway. :)

Thanks for maintaining the 2.6.32 series!
-r
