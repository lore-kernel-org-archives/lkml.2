Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab0HGNMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:12:54 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:43088 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753021Ab0HGNMw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:12:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SL8xh8vzUvy1w50tfh73izfGRN3JuiowNuJu4K7NCasBnftnF1rdDsndlZAA2a2OTM7LXVzZ9cFdHxaEU4RuaVFRQPFDLy0LlPtWr3uu1dB1/w2w4IzMupSS2UDcY+1zY8JL1MFloW/LU0L2OFxkdt93KH+dkXeHORwps8LhYK8=;
Message-ID: <815343.24396.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: qZ1Nt.oVM1n7KAkuLip4R6u3lCOKxJDpCeMcVIK6UJvCNO_
 EGefKDyXpngb5a4lanvTXlzWyjs0NFxuTXl8LBvJmQDemEJq0sIh2FDvz9dX
 TYLem38z4srcjjE93DdpLa6VVLVmAAp2xBbVCe5d9r5QJ5Mse.9yW7rNPNEP
 Qtb886oklPY15SoXdCMY9PSagEcBKsTsRj8rP3ax68vdO8e12MVfGbLzSFCp
 Azz8ODTRHOrD_8cZoxy9e5eyVWolFUnN4X3q3z_GefNKD0vOZsHb4j6VTwOp
 8C9by8evwELWeAehjrjdBPc3EitR9paqlU5s22iA-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 7 Aug 2010 06:12:49 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281092355.5213.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > Btw, I want to add a callback from driver to card
> driver to
> > > be able to
> > > reset card in case of error (windows driver does
> that in
> > > case of any
> > > error)
> > > 
> > > I would use most of the mspro_block_resume for
> the
> > > implementation for
> > > mspro.
> > > 
> > > Any objections, suggestions?
> > > 
> > 
> > Just toggle a power on it. Power off/power on will do
> the full reset of
> > the controller and the media. You don't have to
> reinitialize it, as you
> > are sure that it's the same stick.
> 
> Yea, but after such reboot, the device will be in serial
> mode. So, I
> will need to send switch TPC to device. My driver doesn't
> know how to do
> that...., so it would be nice to have callback to the
> core.
> 

Lets ask a different question: why do you think this
particular functionality is needed at all? Have you encountered any
problems which require it (I haven't, btw)?

Windows drivers do a lot of things, but it does not mean all of them must
be copied literally.



      
