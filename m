Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0LOPp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:45:27 -0500
Received: from nm17.bullet.mail.ird.yahoo.com ([77.238.189.70]:34860 "HELO
	nm17.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752945Ab0LOPp0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:45:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 897013.33985.bm@omp1013.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LUk8VU5RmtIEWySJEPnK3nhzRN0RlRg9vrvLGSnqo74g/CAuYJPmQ1TjAlK5dQm6jEzUf2DE2/E8APgD1C6yQOSLltswD+SWjnruj2medbjzsj6Ndr6YVOaxzABHHtmwIgHORrRxwKKfv0b7R6lwtXzcd2CSaT9eaXISHbtRmMo=;
Message-ID: <718694.20560.qm@web29214.mail.ird.yahoo.com>
X-YMail-OSG: tlkoOI4VM1nkW9L5l88pDhbFFOaYEA6GRRjjicXfLS02X_N
 WNHxbWLiri7AO.j_brOO3JQC42IhXn35dcWPmLDzZCrVDJixnQixr.h_nt2t
 uLydbrei.awKhWSa228Zr4Dxk2fHkNGF0CR1XVtRBIa2vOMBmtfyGOIk6qfg
 e38_FSRonCVd9pT4bFeMOkQhgL4e9KhJnzn.rE9.VnZfesSQw_A62E1uhA0G
 0tDD3XyP1VXM7MqMKCoRHu8vbkY_m6l9UgxeMYpCgJNIRVZXsifyFXA2kaBa
 pxMQdnOJEYJRWRWYLboC3PP59BiIpDALROXaV
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 15 Dec 2010 15:45:24 +0000 (GMT)
From: Didier Lagard <didier.lagard@yahoo.fr>
Subject: Re : [PATCH] base: add sysfs socs info
To: linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
In-Reply-To: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<plagnioj@jcrosoft.com> a écrit :
>
> this provide an easy way to register
> soc information
> 
> arch, family, model, id, revision
> 
> as this for at91sam9g20
> 
> $ cat /sys/devices/system/soc/soc0/arch
> current
> $ cat /sys/devices/system/soc/soc0/family
> at91
> $ cat /sys/devices/system/soc/soc0/id
> at91sam9g20
> $ cat /sys/devices/system/soc/soc0/model
> 0x00000000019905a0
> $ cat /sys/devices/system/soc/soc0/revision
> 1.1

Ouch, I've never seen so few explanations when it comes to add a new ABI...

Can you explain why this is needed at all ? How can it be usefull for an application for example ? Why make it a device ?

I mean there are plenty of SoC supports in the kernel (take a look to arch/arm) and none of them need that so far.

So at least we can expect some motivations to include this stuff in mailine.

Bye.


      
