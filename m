Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0KISef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:34:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52504 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583Ab0KISed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:34:33 -0500
Date: Tue, 9 Nov 2010 18:33:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dave@gnu.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: 8250: fix uninitialized compiler warning
Message-ID: <20101109183310.2ac49f38@lxorguk.ukuu.org.uk>
In-Reply-To: <1289321723.2260.14.camel@cowboy>
References: <1289321723.2260.14.camel@cowboy>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 13:55:23 -0300
Davidlohr Bueso <dave@gnu.org> wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> This addresses:
> 
>   CC [M]  drivers/serial/8250.o
> drivers/serial/8250.c: In function ‘serial8250_shutdown’:
> drivers/serial/8250.c:1696: warning: ‘i’ may be used uninitialized in this function
> drivers/serial/8250.c:1696: note: ‘i’ was declared here

NAK - pleass see the four or five previous discussions on this one.

The current compilers all seem to get it right anyway.

Alan
