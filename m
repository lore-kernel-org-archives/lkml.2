Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1BSFwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 00:52:23 -0500
Received: from smtp103.rog.mail.re2.yahoo.com ([206.190.36.81]:21032 "HELO
	smtp103.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750849Ab1BSFwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 00:52:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=Tl+RuSdY6PaDppuA8bvJSrzrf1y4zxZUUHi/QGSF3QIjRs6vx1N9L4iF++zLrSzOFaJ49l5VrCSRpDatNnSmQZen+x7uwt28F7mL5Jv0Vuf7Z8rkuiRIUwV2t/u1rJieJIWJvPp06coUZyRFVy3YC1Ucdz0KNSShi7vfkJjPo3c=  ;
Message-ID: <556947.8414.qm@smtp103.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 1RE9YuUVM1kTdiPdHGYwdRQlOKn2J4nG888OBA2ogwOIOJa
 TtiU6nVV6mz6qb8IhDEOWmv6lI069Ylz0zYrHHgi1vhZ0t2tAKEB3H_yHLa2
 V3448CnydnML2Q9siNE75f2RJCVP0xHMol2RwWox9hqAH.FQuzFCTFq_4ufX
 DRt0KdRDyMFKQuZiwRtDmXlI0i3HEIPKEnJiLDPC8HcmFVihf8vRiId6VWHi
 R8qM.OALEeiO_rkWGaqWTBBXrOhV1FKlIPHSxtVrISIxB4wVjfDUg8VPsSVG
 hTS85_tjCfkhlS94ayA--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #28832] [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Date: Sat, 19 Feb 2011 00:52:13 -0500
Organization: sh0n.net
User-Agent: KMail/4.6 beta4 (Linux/2.6.38-0.rc4.git0.2.fc15.x86_64; KDE/4.6.0; x86_64; ; )
In-Reply-To: <8H3lez1sawF.A.7vG.KAxVNB@chimera>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.7vG.KAxVNB@chimera>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 13, 2011 12:05:21 AM Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
> 

I've left laptop on for a day, not seeing this anymore. Please close bug 
ticket (but I have another regression coming up in another thread for 
something else :/)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28832
> Subject		: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period 
of
> time tanks causing contant drops Submitter	: Shawn Starr
> <shawn doot starr@XXXXX>
> Date		: 2011-02-07 3:54 (6 days old)
> Message-ID	: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com>
> References	: http://marc.info/?l=linux-kernel&m=129705125832718&w=2
