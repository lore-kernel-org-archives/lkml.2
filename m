Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab0JHEJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 00:09:24 -0400
Received: from nm21-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.94]:21047 "HELO
	nm21-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750993Ab0JHEJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 00:09:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 756224.20976.bm@omp1060.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=f3kERf5xrTfm+g870pszbaF3TjtSZ2A2EccgYUzj7I7OQVJtYy9mylcIMNXw6F3GDassnpFApSSLQOPFQjCXwxgr3efHGL9pYpHiVeVwErWY/7owm+0sRQLpw7573ijlZAIX2w6hYUwnbN5h/c425OAj8sr1GVSVd7sNW8wyHeE=;
Message-ID: <103889.39682.qm@web120217.mail.ne1.yahoo.com>
X-YMail-OSG: lQMswu8VM1mlIRIGsTzvPy1oAbkjWv2TGKWpZXIVAWFEDxO
 Y50ejpoL16Q0ov_TZcBmSGPSKAt9m.8eARxRH_i4mDhuOV1TJvnO.ZvtLSPu
 jdQKu0y5Si1_W.xKpDZ4iOD53B0hTKCpgHaEldIFJTfChhmz4IbVXcosSsUA
 2hMxL8Xcy84JSwbK.9ym.VmHKmrizfW7T3JwKc7qd2QbBveC48KtGC781MRG
 n.Rrl9OnFOYXsZd3ZUx6HENPfYw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Thu, 7 Oct 2010 21:09:21 -0700 (PDT)
From: Man Spaz <man.spaz@ymail.com>
Subject: Tips on debugging suspend/resume failure
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
I have a machine x86 arch with no serial port, only console. I have a suspend/resume (mem, not hibernate) problem (not sure which one it is, if something fails on the suspend, or the resume fails - but it does seem to go to sleep) that doesn't suspend nor resume at all, using stock standard x86_64 kernel.

I compiled everything as a module and removed all unnecessary ones, so I cannot isolate the problem to a specific driver. This very same machine had no problems with <2.6.34.2 kernels.

But the question remains, how to get debug out? Is there a dmesg buffer that can persist if DRAM is being refreshed perhaps? Is there another way to skin this mongrel, I mean cat?
Spaz


      


      
