Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2AIVAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:00:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34142 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab2AIU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:59:59 -0500
X-Sasl-enc: 9mnQKfrdtvWXoojWW4bjBX/eNv+P0EEhIOgnrp+S5GNW 1326142798
Date: Mon, 9 Jan 2012 12:59:53 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] big staging merge for 3.3
Message-ID: <20120109205953.GA9000@kroah.com>
References: <20120109190827.GB9440@kroah.com>
 <CA+55aFxjj0Bji2ivUPc7g5E0bz7Gft7a9uNbeDP4aQABhgTwng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxjj0Bji2ivUPc7g5E0bz7Gft7a9uNbeDP4aQABhgTwng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:17:15PM -0800, Linus Torvalds wrote:
> On Mon, Jan 9, 2012 at 11:08 AM, Greg KH <greg@kroah.com> wrote:
> >
> > Note, you will get a merge conflict in the
> > drivers/staging/iio/adc/ad799x_core.c file, but it's pretty simple to
> > resolve (just delete the module_init/exit calls, and keep the
> > MODULE_ALIAS line).
> 
> Are you sure about keeping the MODULE_ALIAS line?
> 
> It was removed by commit 55e4390cb04e ("staging:iio: Add missing
> MODULE_DEVICE_TABLE and MODULE_ALIAS") which added the
> MODULE_DEVICE_TABLE() line for that driver instead.
> 
> The natural merge would seem to be to remove that line too.

Ugh, yes, you are right, that should be the correct thing to do.

greg k-h
