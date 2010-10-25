Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0JYQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:05:59 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:27339 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756378Ab0JYQF6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:05:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=le78U0FWgdsaMaaOpn9+7UEuFppESmdDQ5GLzfB0G77CH1fl5FIQ+KYGUQwWUv6xKSR6KzaClVFiOUadgB7/qlFj3HzIMTtGAB0xyZ6pg3gFvxrzsL+ZhzwOcOgMp6dp6oOtSe93PCyx3y7RjW2aoasBCfTPDY5pHl7XFmHf5pc=;
Message-ID: <728583.65798.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: dnfmy5sVM1k3FZgD9Ukl8p9atWapG7gTlPReru6TjGTI2a0
 .Fa8vUw8A3N.UL2j.cAvS9IrFta6RMHEj4GPqgMj393nwY0uuOEjwdf_q8zV
 BVf8zj2l9Kw4d7qclNogC2yxQuXE2FrCCRId84NyLAxb54WGV40l5TR67_x0
 jtNWdrrGfCCkY5TGebyN_7EshGkhXDxWAlmW94N3DzDUu.gB4nIEbSUjJoeh
 5u0h47kgkB6EdwXLbbZ1tIHKDTAf7ux_22xno6irwCCMQATW1FASCHmzEBA0
 ndtIskKgrc5YOKrdp3CD1FJ8FCeY1poxcgtdrK1wLJ1GeJT0e1V9UY2cJKZu
 cRRz03vMJAOHNXrJegzLbsA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:05:56 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 20/29] memstick: jmb38x_ms: rework PIO
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-21-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 20/29] memstick: jmb38x_ms: rework PIO
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Rewrite PIO code to be just simplier
> and shorter,
> and comment not so obivous parts.
> 
> Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
> ---

Yet, you are fixing something that was not broken before.



      
