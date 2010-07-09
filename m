Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0GIW3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:29:38 -0400
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:39796 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754634Ab0GIW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:29:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 271956.75707.bm@omp110.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=zRKBgs/wFkGGYbvz6DvDIVP1A4FFxT9gtT2UrPa4K6IjA/JhGBchIah9ey6pl0Vs5nmGLl7IslGa0KCK6AZ4kT1qmRY6YMB+mdtMq0VZGhewrToPqOxnfVzbWpE/t/MNI38XqnM0r6E2VaAUo7VAMTnZomFrFfj1H9Lk8mC5Ev8=;
Message-ID: <170016.53786.qm@web88004.mail.re2.yahoo.com>
X-YMail-OSG: zBQUBkEVM1mvlksKruZzbbv_MDV13w9yfOdNESCv9lcuCB6
 JGKYlju6Ptr90Us7_2YB0kIJ_alTEJfhQXX_Zwbc6CYNxdMg7Qp5GFtbQKuI
 HEC2dcG5sxy2jwgwa3lAL7BUpVdPKWnuY3MzvKDoa.dwoDLIF56sunVuAQ1X
 bHWJD.LH8jPMgYyK7Z8EogIeJlllV6i5K0YfOCc6hx5VihVJEpHVdDoxpFLp
 UXngshDOIkcNbSKWFHQ1ZEp5hKIeF7amTuCGnvAFw0msyc1lOoOfeZu_6jZj
 WPISTObpq4INdmnSa.SxIkdrET_cG5flzS_b7euaOYycao9mF8wHEWrv60ix
 _bWNYCTA9TWgSYjWFQAN3JWSipLbB
X-Mailer: YahooMailRC/420.4 YahooMailWebService/0.8.104.276605
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.YHB.IMmNMB@chimera> <201007082300.51672.shawn.starr@rogers.com> <201007092301.25839.rjw@sisk.pl>
Date: Fri, 9 Jul 2010 15:29:36 -0700 (PDT)
From: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <201007092301.25839.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

From: Rafael J. Wysocki <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kernel Testers 
List <kernel-testers@vger.kernel.org>; Maciej Rutecki <maciej.rutecki@gmail.com>
Sent: Fri, July 9, 2010 5:01:25 PM
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo 
W500 laptop

On Friday, July 09, 2010, Shawn Starr wrote:
> On Thursday, July 08, 2010 07:41:40 pm Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> > 
> > 
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=16311
> > Subject        : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500
> > laptop Submitter    : Shawn Starr <shawn.starr@rogers.com>
> > Date        : 2010-06-28 0:45 (11 days old)
> > Message-ID    : <201006272045.17004.shawn.starr@rogers.com>
> > References    : http://marc.info/?l=linux-kernel&m=127768633705286&w=2
> 
> Continues with July 7th, snapshot of 2.6.35-rc4. 
> 
> Some more info: I have USB in use while trying to suspend.  A USB Microsoft 
> Mouse and a QuickCam Pro 9000 camera connected.
>>Well, can you please try to suspend without the USB devices and see if the bug
>>is still reproducible, then?
>>
>>Rafael

Yes, will try that today.

Thanks, 
Shawn

