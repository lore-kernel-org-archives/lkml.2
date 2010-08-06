Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab0HFK70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:59:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0HFK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aqOmJCBx3jSLmxW8jUBz3J+eqX9aTRzPePHvAlPFVsE7h2/6z5OwT4hUG6SLcxk4c3
         K3oeaNT2BqNw3RkSaDukm0t14Vq4Odr04UGNmmk7K8Iho41/oDBKQq5sBeoWZaUGcC4l
         vmXz/x9gxJ0AzePPeHcd3apdCa+0U38ijeLu0=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <209536.68480.qm@web37606.mail.mud.yahoo.com>
References: <209536.68480.qm@web37606.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 13:59:15 +0300
Message-ID: <1281092355.5213.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 00:59 -0700, Alex Dubov wrote: 
> > 
> > Btw, I want to add a callback from driver to card driver to
> > be able to
> > reset card in case of error (windows driver does that in
> > case of any
> > error)
> > 
> > I would use most of the mspro_block_resume for the
> > implementation for
> > mspro.
> > 
> > Any objections, suggestions?
> > 
> 
> Just toggle a power on it. Power off/power on will do the full reset of
> the controller and the media. You don't have to reinitialize it, as you
> are sure that it's the same stick.

Yea, but after such reboot, the device will be in serial mode. So, I
will need to send switch TPC to device. My driver doesn't know how to do
that...., so it would be nice to have callback to the core.

Best regards,
Maxim Levitsky

