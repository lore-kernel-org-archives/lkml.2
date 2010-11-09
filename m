Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0KISyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:54:47 -0500
Received: from mailbigip.dreamhost.com ([208.97.132.5]:43880 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752344Ab0KISyp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:54:45 -0500
X-Greylist: delayed 7149 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 13:54:45 EST
Subject: Re: [PATCH] serial: 8250: fix uninitialized compiler warning
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-serial@vger.kernel.org
In-Reply-To: <20101109183310.2ac49f38@lxorguk.ukuu.org.uk>
References: <1289321723.2260.14.camel@cowboy>
	 <20101109183310.2ac49f38@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 15:54:36 -0300
Message-ID: <1289328876.2260.37.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 18:33 +0000, Alan Cox wrote:
> On Tue, 09 Nov 2010 13:55:23 -0300
> Davidlohr Bueso <dave@gnu.org> wrote:
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > This addresses:
> > 
> >   CC [M]  drivers/serial/8250.o
> > drivers/serial/8250.c: In function ‘serial8250_shutdown’:
> > drivers/serial/8250.c:1696: warning: ‘i’ may be used uninitialized in this function
> > drivers/serial/8250.c:1696: note: ‘i’ was declared here
> 
> NAK - pleass see the four or five previous discussions on this one.
> 
Yes I should have googled this one before sending.

> The current compilers all seem to get it right anyway.

This is with gcc 4.4.5 (ubuntu 10.10 - latest), released on October 1st,
2010 (quite current).

Thanks,
Davidlohr


