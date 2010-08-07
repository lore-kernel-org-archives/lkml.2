Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0HGQDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 12:03:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41716 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0HGQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 12:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jXnLzchF/1KWiHAfC3OGgLpAIV0EYb/KkULKO4qmMrYJRrL5PGClOezEwVtAZPNkvA
         HSJYWGKAKhT7sDvprF37CFd7BXoKGV/zIleHiNtfgKaQS3z46du2eaY59ZnP2bB8hw9n
         lylASDio+T2B7p0gHxpv+OWBs/ropN1DgoLfs=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <815343.24396.qm@web37602.mail.mud.yahoo.com>
References: <815343.24396.qm@web37602.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 19:03:15 +0300
Message-ID: <1281196995.3300.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 06:12 -0700, Alex Dubov wrote: 
> > > > 
> > > > Btw, I want to add a callback from driver to card
> > driver to
> > > > be able to
> > > > reset card in case of error (windows driver does
> > that in
> > > > case of any
> > > > error)
> > > > 
> > > > I would use most of the mspro_block_resume for
> > the
> > > > implementation for
> > > > mspro.
> > > > 
> > > > Any objections, suggestions?
> > > > 
> > > 
> > > Just toggle a power on it. Power off/power on will do
> > the full reset of
> > > the controller and the media. You don't have to
> > reinitialize it, as you
> > > are sure that it's the same stick.
> > 
> > Yea, but after such reboot, the device will be in serial
> > mode. So, I
> > will need to send switch TPC to device. My driver doesn't
> > know how to do
> > that...., so it would be nice to have callback to the
> > core.
> > 
> 
> Lets ask a different question: why do you think this
> particular functionality is needed at all? Have you encountered any
> problems which require it (I haven't, btw)?

I would image using this to verify that stick is still in place on I/O
error.

If I just power  down/up it, it will loose state, for example IO mode,
reg range, etc...

But anyway, this isn't very important.

Best regards,
Maxim Levitsky

