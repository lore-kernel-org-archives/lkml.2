Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098Ab2KAVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:14:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38882 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab2KAVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:14:05 -0400
Message-ID: <1351804440.2391.99.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Thu, 01 Nov 2012 21:14:00 +0000
In-Reply-To: <20121101210634.GA19723@srcf.ucam.org>
References: <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	 <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	 <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	 <20121101210634.GA19723@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 21:06 +0000, Matthew Garrett wrote:
> On Thu, Nov 01, 2012 at 09:03:20PM +0000, James Bottomley wrote:
> > On Thu, 2012-11-01 at 13:50 -0400, Eric Paris wrote:
> > > What do we have to do to prevent Linux being used to attack Linux
> > > which may lead to secure boot being useless.
> > 
> > That's not really remotely related, is it?  Microsoft doesn't really
> > care about Linux on Linux attacks, so preventing or allowing them isn't
> > going to get a distro key revoked.
> 
> Linux vendors may care about Linux on Linux attacks. It's all fun and 
> games until Oracle get Microsoft to revoke Red Hat's signature.

I agree that's a possibility.  However, I think the court of public
opinion would pillory the first Commercial Linux Distribution that went
to Microsoft for the express purpose of revoking their competition's
right to boot.  It would be commercial suicide.

James



