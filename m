Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1FFDJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:09:45 -0400
Received: from nm7-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.189]:33978
	"HELO nm7-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754814Ab1FFDJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:09:44 -0400
X-Yahoo-Newman-Id: 936860.96385.bm@omp1009.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-ID:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=28hXE+N0JIdsV+mX+4Y0340fnfiKyDBZIjAQ+Vxgqvtie38dSS2kotheCs0v2tagROjBoKUQqkzzmtZh5/fbNswmZHp4IdJyGkZVvypO2qV8Vaofbz10eJfD8eHe4wXslROjNRFFQGSAl1M9QyqrDrw6oOTYGvK4xymh6RTENkQ=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 5bnTzVQVM1lFc7exm.EVnB9mGGh5x9NvHUfh09VLv9a3XAZ
 HvRV0CxO3pGvuACK461JDF.9UTKaGlWXqq8_de4G8EkH.qNY4ct.scjXD4n1
 yQqAAZy2NGQJcUjRROs2x1G9BODXhIGwSu0OA8mFhhmxAjfg4zb3oI4VtAwu
 O3M3VicbZQgtgCuIkaUbIcJbjZWfCrd3pqROfkgfMN7M5xUhPRmcrd1XtsbA
 VKipC9i8SspAvo1wQ6d3j2TaBteBTtnOOsMgX8btL5ml.HFpVe6qKh_JJx9S
 gUgYDhfFbjYtfcOnU201_.bzCMWkJctty.Yu4vE922typ7Q9H7F7.YYLgDgS
 NkZVSnQVlXdekTpXqK.D_c1MxyYtv8R2wo6PuQJqIgwFRLPWPbnXBXi_R6yQ
 vD1wWdvqST2uYWkmjZlzIoRhAd17Ph32IFqZo8EoFpYyixYWuWToQZZJdP1o
 mhn.K6y5qhzfMd_bnq6x6MkRjyzm.NFUbc612sGRgK2LivxSWpqQVbelIQc2
 Z.fBrgxEBCtkEiJnZTIm6nN0Q0dgXkIiGq2my
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #29672] [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Date: Sun, 05 Jun 2011 23:09:31 -0400
Message-ID: <2796152.kfvgntDoi7@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6 rc1 (Linux/3.0.0-0.rc1.git0.1.fc16.x86_64; KDE/4.6.80; x86_64; ; )
In-Reply-To: <SFkDk2sBn_E.A.BYE.dSwzNB@chimera>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera> <SFkDk2sBn_E.A.BYE.dSwzNB@chimera>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011 12:40:37 AM Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
This continues in 3.0-rc1, model=hp didn't fix it

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
> Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external 
microphone
> sound too quiet Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2011-02-19 6:02 (85 days old)
> Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
> References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2
