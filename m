Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab0HELsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:48:51 -0400
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:31844 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755733Ab0HELst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:48:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pOr+jFmp21ZykEgtOmN0bidclx/aWmrPLMGI4p6laJyxMYi7ENckWEzgdnxVeyGQmycczcbnMhoKfhbeP3l05mHOMOz4lwjs7PPPyPpv4pDjyxJFZi7oJxFWtGiJg1AIBRwmitu/J6gTiQpz403kj1vjVY8yF6oXGaZTgiDSrlk=;
Message-ID: <390339.43272.qm@web37603.mail.mud.yahoo.com>
X-YMail-OSG: KLmRqZkVM1kEvubupiEXZdlruPbi5s2vMWjFo2ZoBAksB97
 MGV7o6GzgA_2FI2eCaOkCn0wcEm3KIxgruL2yxmKZ_Jvq6IHvaLlSLvmM964
 2CjWeinyA90Gqc5KQFPY4ePrKYfUeLFVK7cu6ReHz30lQPf94oUEULCmCyxz
 n3FEGqQNcAfp_qWdT2EVTbZdTzxRNkPIpkeFNciK.gWMrx_XeMhO0DqrQL1F
 vcxq5l5lNrVQQxu4qBbSEJnGYdpDHnjimdbYonjUuI1bGJwreScc.kA4njD1
 RoCXgLlhPdjwx3h_bl7_BtIZnXpntUrUep5nQlL2K
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 04:48:46 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281007245.8617.15.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > That's how its called in the spec.
> > Sectors can be larger than 512b on Pro-HG sticks, and
> there's additional
> > TPC_READ/WRITE_QUAD_DATA which operates on larger
> quantities.
> But not on ordinary PRO, right?

Pro sectors are normally 512 bytes.

> 
> Small question, can I use Pro-HG stick in my reader that is
> designed for
> Standard/PRO only? Does your subsystem support it?

It should work. It works for me on TI, which has no 8b mode either.

> > 
> 
> Alex, how should I proceed in merge of my driver?
> Do you have any objections against it now?
> 

I may have done a thing or two differently, but otherwise no objection.
I suppose, you should ask Andrew Morton to put it in.




      
