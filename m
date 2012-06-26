Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2FZXPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:15:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2FZXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:15:44 -0400
Date: Wed, 27 Jun 2012 00:19:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UEFI and custom kernel
Message-ID: <20120627001925.56e350f8@pyramind.ukuu.org.uk>
In-Reply-To: <4FEA4102.2080900@spin.net.au>
References: <4FEA4102.2080900@spin.net.au>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 09:08:50 +1000
Chris Jones <chrisjones@spin.net.au> wrote:

> I've been following the news on UEFI and Secureboot pretty closely. 
> Currently Ubuntu, Fedora and OpenSUSE have pretty in-depth discussion 
> going on the mailing lists about it all.
> 
> Although my technical knowledge about UEFI is pretty vague at current, I 
> know a little bit of what it's about.

For x86 the UEFI "secure" boot requirement is that the user can disable
secure boot. For ARM it is that the user *cannot* disable secure boot.

So in the PC space at least it's "business as usual" providing you jump
that hoop, and hopefully with the tools sorted it'll be viable to sign
your own kernels and use your own keys.

Alan
