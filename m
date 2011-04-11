Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1DKUJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:09:17 -0400
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:44203 "HELO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755751Ab1DKUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:09:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 397233.43279.bm@omp1027.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=l6dVfBtVBVWSCBbQ1rQiO1ANnCZzj+AxArj+goWcsaB1wkXL3dni+6fGbSoHtQ91W+2jRE7gct3BpnAkyTjS5nGx4urxmHmjYSiTqiVQtf1Dq8z0MJw42zCWW8ArPBWSspAfCQNty/uyz47WkH4MLgX1h/2Yjai0QSnNz5yiVXE=;
Message-ID: <312743.30438.qm@web161611.mail.bf1.yahoo.com>
X-YMail-OSG: 8Kk1wV8VM1mHzXYkCSzWPTi.9X3htte2hf4HMcInG1TUPUF
 XM96LvfGjpZE_kclx6biX2CP5qCH0hNTWX6dDz1s0ijBWQCnWnBPWnbSn37o
 mDr3gaT_imkTE6FgDfJSnzKQ3fUAYKBbtIKimQhuxBvq84BQTg6gyOf.yD1E
 cUtMOTU.D1eHuF72dSTpZC47BcVhQz5t2RtmS5wjOW91xHkCVSG265BD5..R
 VBS7lI6M9ysgbzpcURYpBMu7i.e3.YYTNnpLnHOBwoam3TQmhuWu03j8vdmJ
 HmFuq0YWDoRdBVmdYXH8hW2aC6V0MhvYyIUuiw29qgYjLS3cFxKgInzSx_La
 cXMKzIc21ap7395I7uBwAD.5KcqLMIJ12uUbItY1BO0Ia88oDenm1lw--
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Mon, 11 Apr 2011 13:09:15 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, gwingerde@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Shiang Tu <shiang_tu@ralinktech.com>
In-Reply-To: <4DA33FFD.5070004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Are there any changelogs for these firmware files? Do
> they
> > only offer support for newer chips, or are there any
> actual
> > improvements and bug fixes implemented? Users should
> know
> > whether updating the firmware will be of any use to
> them.
> 
> Shiang Tu from ralink says [1] :
> "We always suggest to use latest firmware, because it's
> backward
> compatible and also has some enhancement, bug fix, or
> support of new
> chip.

Sorry, but how very ... Microsoft-y of Ralink.
Something has changed, a bug, an improvement, but we are to guess what it is?
Maybe if people knew how these firmware files affect different generations of chips, they'd knew how to maintain them better. I think this contributes to the mess here.
