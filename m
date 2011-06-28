Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1F1UkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:40:05 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55855 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab1F1UkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:40:01 -0400
X-Sasl-enc: nAyo7CaAaR1pIzUo0cTgYQGHuXrgh5Cue9Ffqd3xe9g4 1309293600
Date: Tue, 28 Jun 2011 13:24:06 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [PATCH] staging: synaptics: Implement error handling for rmi4
 touch regulator
Message-ID: <20110628202406.GA11400@kroah.com>
References: <1306757810-5291-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTim0qum-ZbmaWaFwis7ONAhN+oGFAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim0qum-ZbmaWaFwis7ONAhN+oGFAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:41:40AM +0200, Linus Walleij wrote:
> On Mon, May 30, 2011 at 2:16 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> 
> > From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> >
> > Implement the error handling for regulator in synaptics
> > rmi4 touch screen
> >
> > Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > ---
> > Somehow this patch has been lost and is pending in my local tree,
> > so resending. The slowness of the "big" Synaptics driver to emerge
> > gives me ideas about moving this to drivers/input :-P
> 
> Ping on this - can this go into staging now?

Now applied.
