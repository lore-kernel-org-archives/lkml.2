Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2H1T3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:29:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2H1T3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:29:45 -0400
Date: Tue, 28 Aug 2012 15:25:27 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL
Message-ID: <20120828192527.GA9921@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jgarzik@pobox.com>, Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org
References: <20120827215356.GA27961@www.outflux.net>
 <CAFtxgO5QSYwQcHCbaXoT6pauTYPGpNBC31vufcAOUb5i7c-UfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFtxgO5QSYwQcHCbaXoT6pauTYPGpNBC31vufcAOUb5i7c-UfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:10:48AM -0400, Jeff Garzik wrote:
 > On Mon, Aug 27, 2012 at 5:53 PM, Kees Cook <keescook@chromium.org> wrote:
 > > This config item has not carried much meaning for a while now and is
 > > almost always enabled by default. Remove it and adjust various config
 > > logic and documentation.
 > 
 > It does have meaning...  !CONFIG_EXPERIMENTAL means more stable.  In
 > the past things would get CONFIG_EXPERIMENTAL until they've been tried
 > in the field or otherwise hit some goal in the developer's mind.
 > 
 > Is this a practical distinction?  Probably not, as the markers often
 > go unmaintained...

That's exactly the point. We have 'experimental' code that's been marked
as such for 10-15 years. Maturity has nothing to do with that option,
even if that was its original intention.

The reality seems to be that near everyone sets EXPERIMENTAL because
there's so much stuff tucked behind it, that they want at least some of it.
They aren't choosing this option because they care about how mature the
code is, they're setting it because they *need* something that it's hidden behind.

What *might* be a more useful thing, is instead of adding new options
depending on EXPERIMENTAL, introduce something like CONFIG_NEW_IN_3_6
(and a release or so later, when it's not considered new any more,
drop it). But I'm not convinced that even this wouldn't succumb to
the same neglect that EXPERIMENTAL has.

	Dave

