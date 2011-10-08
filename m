Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1JHXGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 19:06:42 -0400
Received: from nm2.bullet.mail.bf1.yahoo.com ([98.139.212.161]:40501 "HELO
	nm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752123Ab1JHXGk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 19:06:40 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Oct 2011 19:06:40 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 229101.10431.bm@omp1036.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gtXsC5lXRVG8ckjzahlEv1VKRkW6kHzYDnK/KvZ2OWZFein35oHEYG25Nan0wcUfFQIOBVjf4ZwzvSow1B7XCOxoQs+/n0Ewvo8TLScAzvcbnOvl7IryJ+2lDqcnYF4xtyXDv731z+S9won6Nx0t8Vc8LAti90S7p5sk+M+61Qg=;
X-YMail-OSG: mSR03SoVM1lHQu6P3Aoc6muTnGVYZHYhTUZkoMSqoDxX3Kj
 OSG14lT1pVPqad2f1cOeODaofcSxpefv1CCfnG_ss32xbjCBzI5ZvW_Bd4C4
 1HuSr3gdNWQwh1L8nM6_VVe.352qpS.EK4EqD7Lu1hZbh_F2NSm2ytDSSomv
 EolRh8afAdIShxU3yL.bMOTbPgTL2bYue4daXu1Y2hJcALXbdBrBQsa80iHP
 I0cY26F.DmhUXEMkOdyjR5kz5beNiODSBq.t4gfmt64rH6hqTJ.NfbcAtwK4
 9ZuufJT5oQaotTGauP8BHV7eL8hQgTQReKgF0g6R0LeE00xjKou8Q5BEWX5.
 L98Lui85W4XII7vw5K59mnO1ogu_6aW2nQoeIdqZC3WUN0Eu0cqxT_Og.HoP
 iBA4IEvlv_J4b_iFOExjMoN6JcSZQ2BMKQ7hX9xzMrt3HYwxxO4TBukPgrg5
 2q2bLijKT56Lz4SBCOTsKCSAeGasQtwaoNo64yJp5NrBpyPCsxEB9f0XqJGi
 z_wuEMWea8Inl9iEz.QpAbFNsqTJWNlFV50K3l2hP0Pcchkg-
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1318114806.51690.YahooMailNeo@web30305.mail.mud.yahoo.com>
Date: Sat, 8 Oct 2011 16:00:06 -0700 (PDT)
From: AW <arne_woerner@yahoo.com>
Reply-To: AW <arne_woerner@yahoo.com>
Subject: Re: acm/ttyACM0/cdc_acm does not deliver data
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried a vanilla kernel now (built from the fedora SRPM after some help by Piotr H....)...

The command that works on the vanilla kernel (_and_ on the official fc15 kernel) looks to usbmon on the vanilla kernel like this:
http://www.wgboome.org/cmd:P-C,2.6.40.6-0.local.fc15.x86_64.usbmon


(the command "P C" switches receive/send-roles much faster (i guess: less than 1msec) than the command "Z L 0" (I guess 50msec); during that time interrupts r disabled and the ATtiny doesnt care for USB things... *blush* but why did the "old" USB subsystem didnt complain about it? and what about my professional DVB-T USB sticks?)

On the vanilla kernel the command "Z L 0" doesnt work as before:
http://www.wgboome.org/cmd:Z-L-0,2nd-try,2.6.40.6-0.local.fc15.x86_64.usbmon


-arne
