Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab0HEMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:30:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0HEMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JpuGM+gjpAnzpjlJ8FnSGr470ATUIjtpl6gooB1oHCKiCH+4K8xNP2GKiRq9LJbP6c
         Q8nJjeQmqTOG/pdBHUewM+NIwP/DWk3CLlvw+PLWBPUFjLqdFxMvSHJB6mNc6FtR49g4
         Api1SjU3uapgiHqv/sSNxx/biIgCsm43H7nFs=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <390339.43272.qm@web37603.mail.mud.yahoo.com>
References: <390339.43272.qm@web37603.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 15:30:37 +0300
Message-ID: <1281011437.9324.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 04:48 -0700, Alex Dubov wrote: 
> > > 
> > > That's how its called in the spec.
> > > Sectors can be larger than 512b on Pro-HG sticks, and
> > there's additional
> > > TPC_READ/WRITE_QUAD_DATA which operates on larger
> > quantities.
> > But not on ordinary PRO, right?
> 
> Pro sectors are normally 512 bytes.
> 
> > 
> > Small question, can I use Pro-HG stick in my reader that is
> > designed for
> > Standard/PRO only? Does your subsystem support it?
> 
> It should work. It works for me on TI, which has no 8b mode either.
In that case, is there an upper limit on sector size?

> 
> > > 
> > 
> > Alex, how should I proceed in merge of my driver?
> > Do you have any objections against it now?
> > 
> 
> I may have done a thing or two differently, but otherwise no objection.
> I suppose, you should ask Andrew Morton to put it in.

Ok, will do.

Best regards,
Maxim Levitsky

