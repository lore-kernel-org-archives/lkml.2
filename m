Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2CaNzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 09:55:02 -0400
Received: from nm9-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.169]:37671 "HELO
	nm9-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754746Ab2CaNy7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 09:54:59 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2012 09:54:59 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 805906.23743.bm@omp1066.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=grR0kS7CBq0FPWdqc9wdLO5cL7s58/m5CAbOmJxKE45qdQZUD3clHGzTtMkYiIlWR6H5MKu9oyPMxW2mxgR+E0SGedK250qzjdDTExger5rwl2UEGOG0OEHOl4/lsl6eLRELshFSyxXd1fxpg5ImvWa4EeRRN3R57ii94IZjwXI=;
X-YMail-OSG: _ml1_0EVM1lUwndi_fQPXkAzoWlrJVqTP4uPoU1GdpOM3I_
 6YzfX1khu9ltTekO3M4Mp_bn6LShiwfQVZvodjHhQCF5eP_Pv0tzO0dCqwqE
 b.CCPE4AHswMrIvjjebzJ5p6nt8Ym.SYtLfo_NkN6Emx_CKMG6h.JIXiiy.Q
 RzUty_RHz5bkD84xdh_W4IU85KYW9gxnro853Uf4VyF.j2xiRBpxzw_2JiIx
 bkWqc1h_0qQxrCkW4w5YvTw0KJkGSM2iUphVVom86F393Ecdq_sFnTZVUZto
 kFGcRub4kkKHI1nDx7FDVD24T_9jJi8uVwwtz21ibq.Kbx6PM5sTR9DGqkgH
 7ObiK3JTVmfwW2VK.i1L.O3_c5DkxhPpLo9JWdFC4Tr2c5OThOeHzkw7heXh
 rlw5aU48sVrMTyi7.zYfTZVab7GSnCl.92X.G4f6JArQcyOJzMGAQxMt1EZz
 JSrQv13eSS5rBR1naTVKv80Cs2sdDG5NwCBeuMGFSEJ0y3Dr4XwRXChceWi3
 wGtTZIlt4vGZ.dUX9_H7oQbgahlNI2MKspBh1GxI-
X-Mailer: YahooMailWebService/0.8.117.340979
References: <20120330113915.GE9075@marvin.atrad.com.au>
Message-ID: <1333201767.36239.YahooMailNeo@web121005.mail.ne1.yahoo.com>
Date: Sat, 31 Mar 2012 06:49:27 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: Alex Dubov <oakad@yahoo.com>
Subject: Re: Possible issue with tifm_7xx1 and interrupt latency
To: Jonathan Woithe <jwoithe@just42.net>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120330113915.GE9075@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Jonathan Woithe <jwoithe@just42.net>
> 
> Although somewhat circumstancial, during the debugging of a FFADO issue with
> a user it seemed possible that the tifm_7xx1 module may have been switching
> interrupts off for long periods of time.  For a full history of the problem
> please refer to
> 
>   http://subversion.ffado.org/ticket/250
> 
> Unfortunately the original reporter no longer has access to the hardware
> concerned and the report itself dates from 2 years ago (I kept forgetting
> to report it).  However, it may be useful none-the-less.

Unfortunately, I don't have access to that hardware either.

However, there are really only few operations in that driver between "irqsave"
and "irqrestore", unless PIO mode is used (which may, ostensibly, cause this
sort of interrupt delays). On the other hand, PIO mode there is purely intended
for troubleshooting purposes and can only be enabled through special module
parameter by an adventurous user.

> 
> Please CC me any replies.
> 
> Thanks
>   jonathan

Regards,
Alex

