Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2IHRWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:22:49 -0400
Received: from nm37-vm6.bullet.mail.ne1.yahoo.com ([98.138.229.134]:26678 "HELO
	nm37-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751333Ab2IHRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:22:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 590861.24703.bm@omp1009.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=vVXoSiQHwuZ9hhAZAmBsVJyjJd+k64FpCEUZizrtqRMlrgvjZWkw+MALFrzr7CLLQewIJYYDKlGo1y213emsqmlOMjiFiBNg991bomQKNNySCSxmFtUzyN9xEpUW5qqperBwHtQk8/jhwW5beyLU25I4hAGbbmYai7/weBOYVMQ=;
X-YMail-OSG: bD8AztMVM1kvBCzMpf8KYilh0vcASVFFZXMWsn3z6ZspgZF
 xVURDUPBezXsFhuvz7N40opTubB76FMQR4Y6z9N1giA.dW5Z5cpDg5Mpz39t
 SRGuUneinldokHElMcItRGQwOapLJ1y.EFwbeAZ9U7aaWwmYOHX851Y254_9
 TCvVQOSOb9dt2WZNmcMScvgHYhPOuXSToDGenPijOjyKTEMQd4FU3x_hBL7q
 4wyrfPRZ1MZQC.lAjIfzZrAELW89iLfOcANXH8P_ZNnZeRJD3uqBEEPpudBk
 _7vLpBJa4A0xU3f0XswPRZ.pgcfGLXdPVNddUY6uVk.yXWfjqkIlow6CJjhw
 nT8GLNILD.w0NiwRFHJnkSZll6SNwi1jmUX6zkFyr1n2UVW.aq3lc4SJZOZ3
 upLBrqKWNvoVMaZ4FhobueD_dUdYjwvTSDMaWHe35
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic> <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120830095808.GB24680@liondog.tnic> <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20547.48101.900727.735398@pilspetsen.it.uu.se> <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com> <20555.29361.138287.766030@pilspetsen.it.uu.se>
Message-ID: <1347124963.91847.YahooMailNeo@web124701.mail.ne1.yahoo.com>
Date: Sat, 8 Sep 2012 10:22:43 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dan Merillat <dan.merillat@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20555.29361.138287.766030@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Please try the patch below, which implements the fix I described a

>week ago. It's for 3.6-rc4 but should work in any recent kernel.
>Without this patch one of my test machines always throws a lockdep
>warning involving pdc_sata_hardreset and pdc_interrupt during bootup,
>but with the patch the warning is gone, as expected.

>If it works for you I'll add your Tested-by: and submit it properly.

>/Mikael


I will be able to try it no sooner than next week.


Thanks !

Regards
Adko.

