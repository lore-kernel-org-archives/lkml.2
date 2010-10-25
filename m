Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0JYQLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:11:14 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:23677 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316Ab0JYQLN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:11:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VzXSuu2e7wQrX1MSSH8u9ivyNvwNbAda6jKaPMomiHXtums1QuKKsdg5bwh81ailIxo1kdTTXOxleG85XRSYBGjsCBLGkJ24HHDM3uA0y3BZAHOXk+fX2EWU4Ot3G0NgzMupzC7Qr78Z/4fDvmQHTmxouhcqDX6xpOHp3qzUhWM=;
Message-ID: <506641.42969.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: A_5Enc8VM1ndkpo9mb9RVEN1.dSfuGJcO5j4.yphfy.5YeU
 34dAKfHZuA7gl902tzcyW9XIOeT7IG.FY23jYpxKea1XI_HMIx34KyWkIUqr
 VZqTFKGFkoFg8IeDIT2dasi7tuXPHtZ1jV1CIM7zneLAqdh3hEXTZS16Kgct
 H6ZEwMAvA5wa6jO6fSxZLKQG2H8P3XDKVc2hEnuof8bv9IcxZIGjNMGykcPi
 pp6NkJt2cAmqRg4cIqZcJNo.A.DQ49ckzuHWPmOz_xsWvkkVVAzPIraSJPA0
 3TpI_5oqbda8I.O3e8hREeHMGvXFVP94o7fEH3Ev170.58.bXdqstEh5HBxY
 0dJA7pVm0dO100HefSRIhZEVhIVHkTrAJg1AW29RvtkEBzD3PRA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:11:11 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 22/29] memstick: jmb38x_ms: rework ISR
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-23-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 22/29] memstick: jmb38x_ms: rework ISR
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> New ISR is simplier.
> Also it only services the hardware when we expect to
> thus it workarounds the stuck write ready bit hw bug.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

Probably it is.



      
