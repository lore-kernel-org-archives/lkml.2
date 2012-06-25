Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2FYRaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:30:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39072 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757215Ab2FYRaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:30:09 -0400
Message-ID: <1340645408.3359.4.camel@joe2Laptop>
Subject: Re: [PATCH] drivers: staging: android: fix binder.c printk macros
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        Sherwin Soltani <sherwin@wybc.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 10:30:08 -0700
In-Reply-To: <20120625172423.GA1935@kroah.com>
References: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
	 <20120625171715.GA29309@kroah.com> <1340644800.3359.1.camel@joe2Laptop>
	 <20120625172423.GA1935@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 10:24 -0700, Greg KH wrote:
> On Mon, Jun 25, 2012 at 10:20:00AM -0700, Joe Perches wrote:
> > Your patch-bot needs work.
> > 
> > Converting printks to pr_<level> is trivial
> > and should be done all at once, not piecemeal.
> 
> I'm not disagreeing with that, unfortunately this patch also did more
> than just pr_<level> conversions, which is why my patch-bot kicked in.
> 
> So your patch-bot complaint generator needs work :)

Or not.  I think wholesale whitespace changes are just
fine too.

git diff -w can ignore all those things pretty easily.

Using a bot is certainly sensible and sanity-preserving.
I think it just needs a little tweaking.

cheers, Joe

