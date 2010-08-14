Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0HNWMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:12:20 -0400
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:35259 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756931Ab0HNWMT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:12:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JoqHVBr1ZlfXQqoN0PwWwhqLsEuleMq3ZqcIZ5YeSC/AK2pE6FsXOILclOXvBU+/taqPRePr12Gpul/cZkqEaKUc99uWbRYdz0pYEniI815SmcR3PRS+E19OlhLuYlEeMutl/d2J+nlxRSoLODeSI2tXkBTVXIwvPoPDmNXChwU=;
Message-ID: <959882.99862.qm@web52907.mail.re2.yahoo.com>
X-YMail-OSG: 1j1Ny34VM1lNdmpxW3Ij6HVvdHMM6t1ZDOQnxd_V9DCYVhB
 i9vwGlVnFowkOi.MXY0OdGUPAJXrB5aj1gZXSjOv43UAXajyF.pRKkT8W7HL
 6MbsWYTRoOCKVzcUlP1nYtwEMYbl7D6d4g_o0xOpiDcMAnD6SyJ3MdHudYYe
 dRsnP39oDdlFKHxABoiaFwfZ8Iphmh.2MZ3n4qrh4kS2Bg3U1zCBCsZGux1T
 dFo_jE4Yjo7kCx3wZ9t2pyL4I84ri5aAO5l5h39iTCw2AI6gPjM5jr2JIrN2
 V6ydeMv0wm08LUjvpQoQVaJvA3uusSBaXNPtssDTIxkj6r6tOSTTLd4YaPg-
 -
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 14 Aug 2010 15:12:16 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [stable] 2.6.34.4 build failure
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this problem on two of my machines as well, both of which happen to be running UP kernels. (The SMP machine was unaffected.)

Adding <linux/jiffies.h> to vmware.c fixed the problem.

Cheers,
Chris



      
