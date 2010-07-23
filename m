Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab0GWOLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:11:37 -0400
Received: from n8.bullet.re3.yahoo.com ([68.142.237.93]:38495 "HELO
	n8.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754249Ab0GWOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:11:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 242398.95591.bm@omp303.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=EYlzRJjmPieLhg4iCkeNQRLQVfYV0HUK16+D4MvflzRuoTDRM2qz1lfAmkOpB7pFjcidCIwiiJ+B8nj8TplOI2YPSXL7n9DmWDrenahR0YoPi/4F3saH1hMocm/vJnInjOATSuHG/Y9Cc+uKgGy6lrCGNgnS4il0I17tya4bEJI=;
Message-ID: <123290.24094.qm@web88006.mail.re2.yahoo.com>
X-YMail-OSG: b8yjSW4VM1keUrufFCavgEEXstI_4i9w5NTaS3irYAzn3RB
 8UrTNuB85aw7JxfwHL_n1Q0tth9sifODOvGws1rF2xgo3wNE8JGaMmWEHGq5
 Vw6wgw5oSrgmq8rx2HwALlRpHKNlmNon4H2KuEdljDi4wllqehE.hZQt5_.t
 PAFXM7XltIDRXoyD8S_g5ip.9NmR3uTCd8wf_oGQ2xLzbuyK5DlJOH8xaQF.
 gT_rqNqmvSofDdJ67tprcF9cmvM.Nw_OUuc94OgJLW6uG1nB1CIorox9jQ4c
 5Oy6UC0Xt.bRBJCntEtaAghMpN3O6nBLwfgtm5s1KVcym58Mj4ORwVPu434E
 mASIh7wBsLv0NiM7EXkBjrYameXHcTtNucxAWbqyvV17OGvrv
X-Mailer: YahooMailRC/420.4 YahooMailWebService/0.8.105.277674
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.OLB.i3XSMB@chimera>
Date: Fri, 23 Jul 2010 07:11:34 -0700 (PDT)
From: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <tneGvaw1wLL.A.OLB.i3XSMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Still continues. I can however hibernate and resume from hibernation ok.


>----- Original Message ----
>From: Rafael J. Wysocki <rjw@...>
>To: Linux Kernel Mailing List <linux-kernel@...>
>Cc: Kernel Testers List <kernel-testers@...>; Maciej Rutecki 
><maciej.rutecki@...; Shawn Starr <shawn.starr@...
>Sent: Fri, July 23, 2010 7:47:31 AM
>Subject: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 
>laptop
>
>This message has been generated automatically as a part of a summary report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.34.  Please verify if it still should be listed and let the tracking 
>team
>know (either way).
>
>
>Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=16311
>Subject        : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 
>laptop
>Submitter    : Shawn Starr <shawn.starr@...>
>Date        : 2010-06-28 0:45 (26 days old)
>Message-ID    : <<201006272045.17004.shawn.starr@...>>
>References    : http://marc.info/?l=linux-kernel&m=127768633705286&w=2

