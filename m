Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1ESIUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:20:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56850 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab1ESIUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ffg5TUqULCzdqegsMxesfGQNa9iZ3oKuzGMoNiaVVAHUmOOoFDHjmd9iDWlOKx6R7o
         CI2tK+WOuYU5goqNULZe1XKr0EpgvpDZ0GdR8xRxCftyZe1GmzDd/rb9skv/X09KHD4u
         J7H9yfGh4cGH1KdVMH8Jb31G02l4pKMM4Cw2E=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
Date: Thu, 19 May 2011 10:20:34 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.3; x86_64; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Jiri Slaby <jslaby@suse.cz>, stable@kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
References: <4DC9983B.4070006@msgid.tls.msk.ru> <20110519002505.GB8697@kroah.com> <1305776367.2576.0.camel@mulgrave.site>
In-Reply-To: <1305776367.2576.0.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105191020.34873.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 of May 2011, James Bottomley wrote:
> On Wed, 2011-05-18 at 17:25 -0700, Greg KH wrote:
> > On Wed, May 11, 2011 at 12:34:51PM -0700, Greg KH wrote:
> > > On Wed, May 11, 2011 at 02:19:17PM -0500, James Bottomley wrote:
> > > > On Wed, 2011-05-11 at 08:30 +0200, Jiri Slaby wrote:

> > > > Hmm, it's another missing elevator guard, like this patch:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=130348673628282
> > > > 
> > > > I think the bug here is that q->elevator is null, so dereferencing
> > > > elevator->ops gives the bug.
> > > 
> > > Is this patch going to Linus anytime soon?
> > 
> > Ping?
> 
> I pinged Jens about it yesterday; he said it should be on its way to
> Linus.

2.6.39 was released without it ;/

> James


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
