Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab0HERrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:47:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36979 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab0HERrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KyNlaMBy66dOS65GCjAIyc62SB7tFoPhTDlsHKAvQviT5jdqWwedH19lDaadugyGNU
         CEl3tWerw3Cl5fEznGc0bNGBv8aNhiDr2nBdKfIwtj79ijVlW+9WyXWh3ljVkBgCWdUN
         G70jIvZj4WwPFNTyif7vFzJZbwyVtGm9r8mw4=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281011437.9324.14.camel@maxim-laptop>
References: <390339.43272.qm@web37603.mail.mud.yahoo.com>
	 <1281011437.9324.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 20:47:42 +0300
Message-ID: <1281030462.23959.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 15:30 +0300, Maxim Levitsky wrote: 
> On Thu, 2010-08-05 at 04:48 -0700, Alex Dubov wrote: 
> > > > 
> > > > That's how its called in the spec.
> > > > Sectors can be larger than 512b on Pro-HG sticks, and
> > > there's additional
> > > > TPC_READ/WRITE_QUAD_DATA which operates on larger
> > > quantities.
> > > But not on ordinary PRO, right?
> > 
> > Pro sectors are normally 512 bytes.
> > 
> > > 
> > > Small question, can I use Pro-HG stick in my reader that is
> > > designed for
> > > Standard/PRO only? Does your subsystem support it?
> > 
> > It should work. It works for me on TI, which has no 8b mode either.
> In that case, is there an upper limit on sector size?
Also, you don't use the MS_TPC_READ_QUAD_DATA at all.
So mspro_blk.c won't work with >512 bytes/sector disk?
Or there is some compatibility?


Best regards,
Maxim Levitsky



