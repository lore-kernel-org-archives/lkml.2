Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0KOOxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:53:18 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39977 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757641Ab0KOOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:53:17 -0500
Subject: Re: SCSI TMF processing; tag allocation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
        Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <20101115144029.5c322b78@lxorguk.ukuu.org.uk>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
	 <20101113123750.GF18258@parisc-linux.org> <4CE0FD24.4030000@fusionio.com>
	 <1289831595.2233.5.camel@mulgrave.site>
	 <20101115144029.5c322b78@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 08:53:14 -0600
Message-ID: <1289832794.2233.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 14:40 +0000, Alan Cox wrote:
> > Realistically, tag starvation isn't really a problem.  It was a known
> > issue for 80s era hardware.  I've got some of the oldest drives on the
> > planet and I didn't see a problem when the clock algorithm was removed
> > from 53c700.
> 
> I'm not entirely sure that is the case at least for some early NCQ
> capable ATA drives 8(

OK, since ATA seems to be reinventing all sorts of bad 80s SCSI
behaviour, I'll concede this point.

James


