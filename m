Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1HPPoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:44:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54496 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426Ab1HPPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:44:17 -0400
Date: Tue, 16 Aug 2011 16:47:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Mathias Krause <minipli@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: clearify structure initializer in notify_write()
Message-ID: <20110816164745.5b38b408@lxorguk.ukuu.org.uk>
In-Reply-To: <20110816150452.GL10560@shale.localdomain>
References: <1312027319-1402-1-git-send-email-minipli@googlemail.com>
	<CA+rthh_AW5Yz2ZiOqOTWquXKnsDEd=YcNQ9HiOWu-deSar0eWQ@mail.gmail.com>
	<20110816150452.GL10560@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 18:04:52 +0300
Dan Carpenter <error27@gmail.com> wrote:

> > On Sat, Jul 30, 2011 at 2:01 PM, Mathias Krause <minipli@googlemail.com> wrote:
> > > Even though this is valid C we should not mix C99 initializers with
> > > obfuscated ANSI C.
> 
> I saw this patch the first time and I couldn't figure out why the
> original code was written that way.  I'm curious, is there some trick
> here that I don't see, or is it just a typo that happens to work?

Typo looking at the original commit
