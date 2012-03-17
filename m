Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946074Ab2CQAGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:06:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34606 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162009Ab2CQAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:06:04 -0400
X-Sasl-enc: F/fralJUwRqAcktevbpa+9rksUvPu4oAHoZjsYEe/0V/ 1331942762
Date: Fri, 16 Mar 2012 17:06:01 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@google.com>
Cc: Paul Taysom <taysom@google.com>, Paul Taysom <taysom@chromium.org>,
        Mandeep Baines <msb@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-ID: <20120317000601.GA21602@kroah.com>
References: <1326405431-988-1-git-send-email-taysom@chromium.org>
 <20120316173610.GA26601@kroah.com>
 <CAKwO_5FCn5Z07ZLBUq6Zu=E0Oki-yL6ytwA7gKjzsO8=fJrCHA@mail.gmail.com>
 <20120316194300.GA19075@kroah.com>
 <CAGagf4eMPjP4ARWc7eBUeCjL=1FLshd33vafySwD1KBMFfB6QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGagf4eMPjP4ARWc7eBUeCjL=1FLshd33vafySwD1KBMFfB6QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 05:10:21PM -0400, Theodore Tso wrote:
> I thought another fix at the USB layer also went in that attempted to
> fix this problem for 3.2, and so with two separate band-aid patches, I
> think we had thought the problem had been addressed.

Ok, that's good to hear.  Paul, can you verify this, as it looks like
you already had the test devices that could reproduce this easily.

thanks,

greg k-h
