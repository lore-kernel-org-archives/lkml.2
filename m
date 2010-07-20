Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0GTAdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:33:37 -0400
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79]:30512 "HELO
	smtp101.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756894Ab0GTAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:33:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=dK/K90UEnkvEHCnUjOGXFNR63MRy8+hW5XbM3UPjBWBPYr56LBWeUYIUYoS0uPvRLaIQahNsttiAkXZnN7/5y3LU/G5fQ00OZwWV/z/XmrJRJnjFfVqhIEJnV9wUwoSzC38kWDBLPswvr8cK9DYCUjKkAwDB570jg9QqeuLcIvo=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 8PFubD0VM1nyJ7vr7vjvMmlWdfREtRhw0Xu36.NzhaSC_3i
 sbIX5ObkWDkz5HL6gYBwSeTytUGP0DWQzWZ4VCxQ4F.6SUiq5fmGk_2jLx5w
 xt33bRWML4A0sMgDP4QKyH4_TJisrjkH2Alk0VxwYW2IZNjDJvGJylLcSpXK
 7p53VAXvVHsD4LIa1F7G544WV2yE2ubTSYAicLcwlnd.NMzE1xI3KqL4j3F8
 mPhAANc9GGrzhpFD9.BcUPDUz_xZ5dvXjerV_s6lcFV5jLDec86NriK.PoKR
 GCvxrEE8wkDXBomcuqunpfKCcfr3XUkvQxZgFrXCq_oXWAi1uus4z56GlKed
 QJ83tKBS.fPZRDtT8m13v8YOnycgYPDsSRjChYK9MidGtBsfjiAW0RO6JaNH
 7C11ICqABoRO3Gjo0ZKpN3Jr3V1mfTT7iMNSREw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Date: Mon, 19 Jul 2010 20:33:30 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.92; x86_64; ; )
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com> <201007082336.25201.shawn.starr@rogers.com>
In-Reply-To: <201007082336.25201.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007192033.30849.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 08, 2010 11:36:25 pm Shawn Starr wrote:

<snip>

> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16311
> > > Subject         : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo
> > > W500 laptop Submitter       : Shawn Starr <shawn.starr@rogers.com>
> > > Date            : 2010-06-28 0:45 (11 days old)
> > > Message-ID      : <201006272045.17004.shawn.starr@rogers.com>
> > > References      :
> > > http://marc.info/?l=linux-kernel&m=127768633705286&w=2
> > 
> > I think this might be usefully bisected. Shawn?
> 
> I'll have to try bisecting this weekend. It continues in Linux sh0n.net
> 2.6.35-rc4+ #1 SMP Wed Jul 7 23:58:41 EDT 2010 x86_64 x86_64 x86_64
> GNU/Linux
> 

This continues even with no USB devices plugged in. Will try with today's 
snapshot build from Linus's tree. If this still happens, I'll see about 
bisecting.

Thanks,
Shawn.
