Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966574Ab0GSTsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:48:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52794 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966448Ab0GSTsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dwQkxXJfmYpLViQgy10ZGpVjZhGHCzNmSx201aOyK1835CmoT+7FvK9LCNdkmkPUCj
         TZ0onKESyq6Zjp7jId4/T21I5B3dbdEgSvgOlqrFcN+3hAwNrIsfgfK/W7H/fdacv69X
         oYMxV/Rwlufo61ZqdaBEQBJJZD4U3Shwkavyk=
MIME-Version: 1.0
In-Reply-To: <4C42099C.3070708@kernel.dk>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
	<201007142304.48660.rjw@sisk.pl>
	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
	<4C42099C.3070708@kernel.dk>
Date: Mon, 19 Jul 2010 21:48:04 +0200
Message-ID: <AANLkTik5VjJsdWhRcxCGCoayMTZRUwTNUzWNpqYxjzLs@mail.gmail.com>
Subject: Re: 2.6.35-rc5 inconsistent lock state
From: Martin Pirker <lkml.collector@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dan Carpenter <error27.lkml@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> I posted a patch for this the other day, but I just now notice
> that it was a private list of CC addresses.
>
> Can anyone try this completed untested patch?

[sorry Jens for my first failed test attempt, my idiocy...]

applied to 2.6.35-rc5 -> error message so far not seen again.
about functionality, well, HD spin up control via laptop_mode I cannot
say, I've a SSD...

HTH,
Martin
