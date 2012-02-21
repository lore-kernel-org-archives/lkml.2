Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2BUECm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:02:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49478 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab2BUECl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:02:41 -0500
X-Sasl-enc: JQJNW25Dirwpv/rSoExzfhhnLDYY4OoV4bZN2dgsle+FAPvb0A2lqhOhaA 1329796960
Message-ID: <1329796956.2226.20.camel@perseus.themaw.net>
Subject: Re: Linux 3.3-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 12:02:36 +0800
In-Reply-To: <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	 <20120219.144947.660678318380307878.davem@davemloft.net>
	 <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
	 <1329794974.2226.11.camel@perseus.themaw.net>
	 <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 19:38 -0800, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 7:29 PM, Ian Kent <raven@themaw.net> wrote:
> >
> > Not sure this is the way you'd like to go with this but here is a patch
> > that bumps the major autofs kernel communications version (as yet not
> > even compile tested).
> 
> .. and exactly how does this fix existing binaries?

It doesn't but changing it for exiting binaries will break existing
binaries that use a workaround.

I'm proposing this because the systemd folks were happy to do it this
way. But if you would like any other existing user space users to change
to using a correctly sized packet then, yes, it isn't what you want to
happen.

Ian


