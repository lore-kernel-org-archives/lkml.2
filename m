Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2IDKnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:43:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42912 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab2IDKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:43:36 -0400
Date: Tue, 4 Sep 2012 11:46:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Manavendra Nath Manav <mnm.kernel@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
Message-ID: <20120904114618.62a1d89e@pyramind.ukuu.org.uk>
In-Reply-To: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 15:00:16 +0530
Manavendra Nath Manav <mnm.kernel@gmail.com> wrote:

> Hi,
> 
> I have declared a static const int variable in one driver and exported
> that variable symbol. In another driver i am modifying that variable.
> The other driver prints the modified value but the original driver
> retains the original value. When both virtual and physical addresses
> of the variable as seen by both drivers are same, how is this even
> possible. Is it a kernel bug?

It's const, why is it even a surprise. If you don't understand what is
going on then I suggest you disassemble the code. That will I think let
you understand what is going on.

Alan
