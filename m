Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0CZPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:08:08 -0400
Received: from web94906.mail.in2.yahoo.com ([203.104.17.156]:26416 "HELO
	web94906.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753832Ab0CZPIF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:08:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LWxaymExmJGDk0HbLGIaEcSY72Ve6xhkBgbAH9FTChobcm7qGilceoxmFcXas41V29w6+WGp+y9VDTJhTjpXyZXblEdbXUXxFHaSowoAa5kyc5+A+LN2mQZxkXhAn+a2TxeVtECfDMBxFBd+TkeMRsuBzdbn2ldVsVyFRxg+I3s=;
Message-ID: <114559.15769.qm@web94906.mail.in2.yahoo.com>
X-YMail-OSG: mTyP744VM1lXyqFtjtinqdFGoS3hUs4EQop8ortrusFxAzX
 0Moq.AlDydKdFdO7H2wV29daxC1k5HlPrGdQZrAgflUJcaysI2PZyYg5P8M0
 1ttReal9UynWLtJ8u8rPyGEk6BLrjv0NHZmwM5BNodBsoM8x5aSUttUwpBng
 qNlYHkqE4VIe1U1n9nmCLspE62K.l3btVkgI5NgkNGQszabbvcU7jt.Xp9qH
 xYLrC.Nvmssm1bw8blF0p4gXAOgAXxWOxsNXDtx9nUwcCz1gonbWsoJgNnbQ
 _bDbeOM6sd.iT2LaPorNUSSQ-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 26 Mar 2010 20:38:01 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
To: pavan_savoy@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20100325233030.57ae6544@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

--- On Fri, 26/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
> To: pavan_savoy@ti.com
> Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
> Date: Friday, 26 March, 2010, 5:00 AM
> On Thu, 25 Mar 2010 18:20:16 -0500
> pavan_savoy@ti.com
> wrote:
> 
> > From: Pavan Savoy <pavan_savoy@ti.com>
> > 
> > Push the max ldiscs by a few number to allow ldiscs
> > to exist in the staging directory
> > 
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 

What about the rest of the patches ?
Do you have any comments ?


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
