Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2E0OdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:33:09 -0400
Received: from nm27.bullet.mail.bf1.yahoo.com ([98.139.212.186]:23232 "HELO
	nm27.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750846Ab2E0OdE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:33:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 331007.70375.bm@omp1003.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cDZTJoAzIYVIwH/DQ+I9yCqtk66ZPJ6EV+8DyTiliFbdRbnJ77ST2T6j6zbiKZf7tJmV7/fhm8GKyYxGX1BuKr/yk4/D/gBsE/5ZXymSdPHpH4bFyfw58XA4wrTXWi0q6YIMp8N/I/PoMgk1Swff7DCo8M356VWyJpzmCSDdel0=;
X-YMail-OSG: VhjEGBUVM1l62B0u9KjVk3zfkAk0FxFdGyaXYMEEL2ocqaG
 d.fKKjDZgfdqpncaqA1Tx8R5MrA.FW4lNRvjnT0X8Ghe8CXOQVl0At69GJ6T
 kmzI3MabydEn3C3OBIIqYvIa4xAULssteGq5YyJWiABX5naSbp5lxAMJH6Gv
 4JSoytEsE3p6e7huO.sH5Ok67CPEbGzz0sJcWPLMdaKTpTcTP3JFEkE1MJGC
 Nuq61IFxlGxOPbHCPfQa1azw8yKQE4SrBYlpTVZebOVXzh5o14.MyixmSK2A
 Pb5OGW5GJP7r58aqLEzJOI0F3hmOw7ZwhYNS2bMjgjgf4mFcqphT.XrFP.dW
 ok0vhPWCN9EJ68iVBPn8wuPBcjZTzWVrYLpE7zumExv_ITd2FbX5Tmv5h0uM
 s81gIAazgvja6z6i.6ZlsVA3rpn9ZkbwJfJDEcU3rKo9QkoBP68o2jNwQbjq
 EgxCy42_5hlHKdnJEngz0baoCkTaIuNH3.jlgdVU6X3Pw6VWZW9MPrGBiF6F
 .Z8E-
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1338129182.70493.YahooMailClassic@web162605.mail.bf1.yahoo.com>
Date: Sun, 27 May 2012 07:33:02 -0700 (PDT)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: Re: [BUG] Hibernate not working on laptop LENOVO X120e
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4FC21F57.8030507@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one solution that i found, this is uncommenting one line in file:
/usr/lib/pm-utils/defaults
HIBERNATE_MODE="shutdown"
But i dont know how this solution is right. Maybe this is bug of thinkpad_acpi or bug of pm-utils

Your sincerely, Denis Lotarev


--- On Sun, 5/27/12, Arend van Spriel <arend@broadcom.com> wrote:

> From: Arend van Spriel <arend@broadcom.com>
> Subject: Re: [BUG] Hibernate not working on laptop LENOVO X120e
> To: "Denis Lotarev" <dlotarev@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Sunday, May 27, 2012, 4:34 PM
> On 05/27/2012 05:26 AM, Denis Lotarev
> wrote:
> > Hello!
> > My system on Lenovo X120e doesnt hibernate, when i
> trying to hibernate system power led begin often blinking
> (about 3 times at second), LCD turned off, HDD still
> working, and CPU fan workinkg too. There are no kernel log
> at messages, even if i run DEBUG=1 at pm-hibernate there are
> no errors at pm-hibernate.log. Suspent on RAM working good.
> > Linux lenarch 3.3.7-1-ARCH #1 SMP PREEMPT Mon May 21
> 22:39:59 UTC 2012 i686 GNU/Linux
> >  
> 
> Could you try:
> 
> # echo reboot > /sys/power/disk
> # echo disk > /sys/power/state
> 
> and provide the kernel log.
> 
> Gr. AvS
> 
> 
