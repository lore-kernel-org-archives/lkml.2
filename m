Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2BTD2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:28:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50681 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab2BTD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:28:32 -0500
X-Sasl-enc: pbEY6xs/kVNfv9s3B6X6ZUnzekkyb9p/N04GVzSojXzHuflC+UVoOlatyQ 1329708511
Message-ID: <1329708508.2253.9.camel@perseus.themaw.net>
Subject: Re: Linux 3.3-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Feb 2012 11:28:28 +0800
In-Reply-To: <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	 <20120219.144947.660678318380307878.davem@davemloft.net>
	 <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 12:02 -0800, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 11:49 AM, David Miller <davem@davemloft.net> wrote:
> >
> > A real shame, this should have used "__aligned_u64" from the
> > beginning.
> 
> I agree. Sadly, this is exactly the kind of thing that is *really*
> easy to overlook, and once it is overlooked we're screwed because
> fixing it just breaks the native 32-bit case.

It sure is.

There was a suggestion from the systemd folks to bump the kernel
protocol major version to 6 and add a packed structure for use with that
version and beyond. That's a bit ugly too but won't break things that
already work around it in user space for major version 5 and avoids.

I've not got around to checking if the patch works correctly and
finishing it.

Ian


