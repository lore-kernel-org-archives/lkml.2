Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1KVGux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:50:53 -0500
Received: from nm27.bullet.mail.sp2.yahoo.com ([98.139.91.97]:38374 "HELO
	nm27.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753272Ab1KVGuw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:50:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 878500.44866.bm@omp1013.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WcAN0c2eZKV+BF9v1+0OW45LuZwXXN1NRCkSsBtY9qtmAESyn34EiiyEloIgIFOaj9Q/YNxXZ07C9nOXg/7/2fE2YN5o4GUBoW4+2m3of2M3gQ4P9IglqsvF9VSmbGMfFhW2xSpR/s7R5gSDUEurp/olW67yKnQUa3RP9dvWC1g=;
X-YMail-OSG: oVAjykEVM1mh0xyM90E5Ou114ZMOpo5eGT04BY6l4yD.rCz
 Km9aBVf8.a8Dp8tvLfzBaOlJoSw.IiOhelGk2CPl4_i5guxs5.g61S7sPDnq
 KLZPHCAKuOsFNZcOKfJw6xKaLzftvNv3yFfoUzDIS8mwAuOEVoKWsUkdkl9w
 3rfcHVxPnpKLjs0cgLo8QGNAhk6Lgh5iKqAolahQLHOIaUMqhW0LNHDuxXHz
 yynJWdEFC1pMw1uZwuNfZVtIp7rl8szUNwQPy4ifXJuJY7sNjJcyu5592xQj
 t6IikaE25Z4xGjcL6HM0SAR_lR090bcuoGfYoOtwp7jjHV6oE3qE1wfLtBVl
 7YFPxifoh4pIch_4ni8TCmfeLwlB0cjFlA272BsTIE4nYIJge.6we_g3t7ia
 GCAgZTp0wpjuoQOIpNXZ6AOMnmMyFr3DJlKA_AUUOq9IOlqi4_2MCZ0l2E36
 ngca11g--
X-Mailer: YahooMailWebService/0.8.115.331698
Message-ID: <1321944651.57994.YahooMailNeo@web30306.mail.mud.yahoo.com>
Date: Mon, 21 Nov 2011 22:50:51 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Reply-To: AW <arne_woerner@yahoo.com>
Subject: Re: acm/ttyACM0/cdc_acm does not deliver data
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yesterday i changed some features of my self-tinkered USB device (especially no deep sleep anymore and other measures for faster reaction on interrupts)...

now everything works fine again (with fc15's 2.6.41)... the USB TV sticks work good again, 2... :-)

thx for pointing me to usbmon (it helped me to c that my device is not USBish enough)...

-arne
