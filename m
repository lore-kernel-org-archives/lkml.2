Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0CUVc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:32:58 -0400
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:41906 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753745Ab0CUVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:32:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=CYbJJRPztMWfGycOJ/CVePfh0/blVpFdw1xMh6nFqsKTqArWFpf/Pcq7KwfJ9SJqTh2HvnZayznra0nq/RZM793aaCafp0JFZRlC4Uh2SO4ykReKWALz0/w6aBE7bjIGHzMEIJfCq8CmM/9MwT2Bfh2GKH1fsEzeuy+DfaQSJfs=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: hcTw8isVM1neNV59SHDv7IapI77T.q5w_2rMs9.mOLpwbPXnp6IvulJwtNVpaP_mvnlzfwKpeoW8IaLOAsUGLisiGC3d1tD4PTGX4jMphyZiCjEUoUOTKJUgWfjjEx7RjlCuLSKxMcmfdDybz4arhuZxp_U33CJaNVdnQ_s2jWB_EwS0kSGhw_jZOvYG2E4eTEy93ATmkeCj7dte._3kB6ewNZMS5TgJ2pXCeON.wDi.Lt9Ltd5hsVyYvtb1DExn2vonAIDiIuK8_DTx1iUX3Yw90nmb8_AWmk3lIvMx6N.uBVlIMBd5hPDPAIhEltaYM9DBY93o5qZ3q9yV9M9Oxphm53jBX9L4QHHmT.XgZA.NUjCO5Hx1vWaP7X0VLs8vpu5UWOixEzNB5rRQcgduP1X2x8rLuI7QrtOdArR59J4I9TzNiUudoHcIFK2Q
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15245] [2.6.33-rc6 Weird JCPU times?
Date: Sun, 21 Mar 2010 16:25:53 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.34-rc1; KDE/4.4.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.3RF.-PopLB@chimera>
In-Reply-To: <hTwaxgnIZ2O.A.3RF.-PopLB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003211625.53989.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 March 2010 04:30:46 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15245
> Subject		: [2.6.33-rc6 Weird JCPU times?
> Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2010-02-06 7:24 (44 days old)
> References	: http://marc.info/?l=linux-kernel&m=126544107816889&w=2

Please close it. I haven't seen this anymore and I'm now in 2.6.34-rc1 (March 
17th git snapshot)

Thanks, 
Shawn.
