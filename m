Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030527Ab2I1WUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:20:30 -0400
Received: from nm7-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.155]:24175 "HELO
	nm7-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754427Ab2I1WU2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:20:28 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 18:20:27 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 522583.92176.bm@omp1040.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cuiZXfFYPj4pdGImDfs238zQCmbRg5KixF4h/YCIWBUU8hWozqSNyzSnneqwXQnwIDh/GlMP/EYxoCHQbWXf6lcTAxxqK2kicQFxEdr0OCfW3cm47ykEqiPLv1CEuxZCseB4TQX+LJDjeNpKrYG01M5clY8GVlS2mjpf4IxtSPk=;
X-YMail-OSG: ottCELAVM1md5H0oeXRudoJLR8w37S4SDc1d4Db_PF5af_1
 V6NS8EsYG.iGCQKdKZ8JYuF3UPxSE5V6VXv.AdM57tw3wQygEpZ91.BZmquq
 xV3nVLSGpEgMW_gndBOlzTgmaXbCZu2oyikRhSi2pkb4JlnYpDd5gcUgaX5z
 pSE4hoXc2gzL2rKmqb9L4NhWWA188iOBdZYJbSRNAW2I1mjdwBiOPz2CiddA
 wFLzsM4Nrh_hPCEqThiRRiAt41WqHhmGhFgJ.CSgv5q9cv63P08WMJf3imB2
 qL.ESPoxFJLrffEpKSnMfmp8GoLMbxMlwnW8AHK0U4NiPE8TB6t4KPxoBbM5
 x.TBnn0gG7r0v5DptpRl6TOLih5kapEOjUQ3dI5OFGnc0s3qnNZ.MJRnwqj.
 jTmI0iNELbhSvaIqBu7ZU2HowBsa9bHzbSGxzdZFlIJ7hkXWlzYMXtzWqLNR
 IAJE6rmcb4buxfn6iQraFWalSbkwf2RiaP6BqjOUDxStVJKQF.yaFW8arvq6
 DyIy.efXsdE9nBHFsHivcRa5qn3ZKrWR8t9CimqSQx__oQErLk4SQKUjY38G
 h_E38SS8EvnTq8w--
X-Mailer: YahooMailWebService/0.8.121.434
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com> <20120928121917.GF5368@mwanda>
Message-ID: <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Fri, 28 Sep 2012 15:15:15 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120928121917.GF5368@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,


Thanks for the response.

>> Linux cyber-ubuntu 3.2.0-30-generic #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

> That kernel is too old.  Can you test with a 3.5.x kernel (or even
> better would be a 3.6-rc kernel).  Those are the only ones we look
> at on lkml.

I did try out Sabayon 10 live disk because it said it uses the kernel 3.5.4
but it did not fix the problem. I will definitely try to figure a way to
test the 3.6-rc kernel.  Do you know any (experimental?) distros that are
using it?  Is there anything else that I could do that could help, like
rerunning any commands/script on a newer kernel?

I eventually plan to purchase a [different wireless card][1] and if it does
not work, we will know that the problem is not in the wireless driver/card.
I'm betting it will fix it for me but I can't be certain.  The bug I'm
having may be an ACPI or some power management issue as far as I can tell.
I'll still be interested in fixing the issue on my current wireless card if
the new card fixes the problem.  I'm not sure when this will happen though.

  [1]: https://www.thinkpenguin.com/gnu-linux/penguin-wireless-n-half-height-mini-pcie-card

Thanks, Kevin.

