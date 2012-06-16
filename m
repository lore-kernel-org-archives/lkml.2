Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2FPJd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 05:33:59 -0400
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:43191 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753057Ab2FPJd6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:33:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 702701.55768.bm@omp1031.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gDEjcPSxqT+C2OgbiWhDP3lKAgj+vGj91AyiF1ZtBqevbkMZ4psiTI9fYwGHh3jygQHd73+wRHqsdPCYvtKuXH12oa+xkOWNSXQiyiWOWi3lZkVY5xBVSapmxejFcqTy5tDelJo/yPzj6IqAzwwUgpu2aE7O+sNox1wsaojAvLA=;
X-YMail-OSG: cfnfIs4VM1lUumxkMBjD6kjwXPrfGvqlbnjRYQl7_kmor8_
 PLFLUsJZQpHtBdjOIsJ4sjq9BKK8HpjIatFKcefi1ZUhCnUAFGnpjYwlSLbM
 qfbWpPniO0kfsHbiADmSKLKP1MEMEesplfG3N0hxckM1g6nE341nyNuZbBV7
 HszoJgbdGBFZX_Kb1AIc4D1qreegexS4LR0Ag7vdUNeglbb1lhydhqkpsKOX
 a_GiTD4Z2PLTOeIkCcvMtkBMBpgJn1lobcgbhR27Ykp5lwdpvZdLclt654KG
 47itSUEfUdf8FHaP3vdKCy4AMSX_h2gq8k8cy4J3_vi6gshB4gY9z3cRIbd3
 rzsVW3RvWtgFfvcRO157mLby8BvZYKg9Fosw9Wqx46FJgEK_Zp8euw3lmbSN
 FkpDZVyGi1hVX..G4oifF2jKt9BOIbDQ.WuJ3UJvWMDQlv7KCWSWVFCkDGry
 xSfWd
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339828893.59679.YahooMailNeo@web111722.mail.gq1.yahoo.com> <4FDC4FF8.1030804@ladisch.de>
Message-ID: <1339839177.39525.YahooMailNeo@web111722.mail.gq1.yahoo.com>
Date: Sat, 16 Jun 2012 02:32:57 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: about interlagos
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4FDC4FF8.1030804@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks
// Naderan *Mahmood;


----- Original Message -----
From: Clemens Ladisch <clemens@ladisch.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Saturday, June 16, 2012 1:50 PM
Subject: Re: about interlagos

Mahmood Naderan wrote:
> As you can see, although interlagos is the newest one which has higher cpu
> clock rate and higher cache size, the bogomips of interlagos is the lowest!
> I read that bogomips is not a true measurement,

Indeed it is not.

> but it senses as a speed meter.

It measures the speed of one particular delay loop.  Because such a busy
loop is pretty much the silliest thing you could do to a CPU, it does
not make sense to use it to measure overall CPU speed, or to compare
different microarchitectures.

> Any idea?

If you want to know how fast your code will execute, you have to measure
that code.  If you are too lazy to do this, search for a benchmark that
represents that code well; for general-purpose code, the gcc part of the
SPEC CPU benchmark probably comes closest.


Regards,
Clemens

