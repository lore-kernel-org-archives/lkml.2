Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1L3X7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 18:59:54 -0500
Received: from nm19.bullet.mail.ukl.yahoo.com ([217.146.183.193]:31748 "HELO
	nm19.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752080Ab1L3X7w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 18:59:52 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Dec 2011 18:59:51 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 680144.75503.bm@omp1028.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=sF/fL1C5EEbWrR4DPQoYHN1qT1EmPZ3Z8D6qOxroAy5n3b3u5TXKsMv62qM31XZfyUJ6ghWj71sIG/FPf3qHi8SZOFnlmh84FBPKbekTPGVtlRpT4cjbExU1aPEPQHWWPXgzfqsczN2ErtqNHB9/6cQ5Kvl6ryBNVNS2/Cu3vcs=;
X-YMail-OSG: AfmUeQUVM1n5_nKchDAm0Vm4T9ryRqsVoUJEwY0ipVCxl1d
 AvSDjG2847lRVYebgcTHNIilZhkoU4KYP0bDQGAmNmFe3XbaXPJmqzUWEshy
 I_RFZaw4j1d42q.pYm6qaqHrXk0f8zX1glXLiiU8rlQbNW7Abb4Unp1JGI43
 .Dk5s9KxtyZdkB1szjVs3UCMiXQx8TGWFB1z854UPa7Q0DSHWJj9BUtju9LZ
 d5vq75Cx5pQ2H..CkcTVOfHeMf1Jr13hwWWyyq44kBzlQnO5CNSfuwE.Up6Z
 13GwMCQMcjWbB8LWSFzFa6zuHC9rjFK6MuudrpaGrBynPaobyd.4q40YhgWA
 QwZdE.dFtTbMJMrfL5t1yLsP0pejQIoatfjwjeeFQrlsj6XS5ujUoX0lt_y.
 kBTlPTCn2rUlC5UqKCMrTnRUIw1l3k68fcdtO9ugmActCHTEkLuzy0eG.aO4
 9.pRAw3AzTEYktsfita_y3dbcAl8OEdHs3lqjoE2qt9ViCEErCuGBjfe2AA-
 -
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.331698
Message-ID: <1325289236.85273.YahooMailClassic@web27003.mail.ukl.yahoo.com>
Date: Fri, 30 Dec 2011 23:53:56 +0000 (GMT)
From: "P." <mailme667@yahoo.co.uk>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>, 653331@bugs.debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Following the advice from Jonathan Nieder I am sending this mail. There is a bug that can cause an infinite loop (stopping the system from booting) when the wakealarm field contains invalid data. In my case, I have four wildcards instead of a numerical year. I have posted the full boot log for kernel 3.2-rc7 in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=653331 .

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=646429 is now the primary report for this bug.

Best regards,

P. van Gaans
