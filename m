Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1CPEZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:25:39 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:40300 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751143Ab1CPEZg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:25:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bzoA01dAsZ67ifnKK/j+9fLMMWolNyyeWOEf6XI7ChwfqjJ/juZCII1DLhpw72dh9QBzGuaDwYDg49MfHOFFQdTnSLxkXGufMQWbOstnvXcTWyqhO16hJJdNKUgT1V85wbb6F2LipizV8K+zFPWPhGhaOoreSX8E6GXHFGED+IU=;
Message-ID: <491744.37716.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: Tftwru4VM1lTT7udwcV4RH0UjHcVFVnM338PuIPxHM_7OYm
 qK0XRlZBGDwxm07INppCU1FPEJmgtmfMtu0zK4MbyC0A5xciRdWOHnnzMSGN
 Hhb2_.cSQV7rT.qeoYkua3Virk50.FY6ksIlf2X6.dFBHiDvM7XNw0taas6L
 0p49yTXJ.j0MhltdltiiND50XKleny1Tpt4tf9n6vThBkvilkFxOd4rIt0l1
 DhVlibjcGI1iT2NFyRL5EsgrtmnsR1N30oEsjNaJIq4EjoU8CpYtArtUqZx6
 UqYEOeuFckhgR9jxsoi0k6BZH6DHcIXOctSFCdz7eDXupORrlOngvWM5HPNX
 EvJXrY4pd_.vAleC3XAfiGRmC_4SFqGuIOwMVeSo41BiY
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Tue, 15 Mar 2011 21:25:34 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 3/4] memstick: Add driver for Ricoh R5C592 card reader.
To: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1299212213-4255-4-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 3/4] memstick: Add driver for Ricoh R5C592 card reader.
> To: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, oakad@yahoo.com, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 4 March, 2011, 3:16 PM
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Acked-by: Alex Dubov <oakad@yahoo.com>
---

I understand, this patch can be applied as it is, and has no dependency
on the discussed scatter list functionality.



      
