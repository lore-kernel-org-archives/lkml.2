Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1HIGxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 02:53:09 -0400
Received: from nm1-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.202]:43848 "HELO
	nm1-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751498Ab1HIGxH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 02:53:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 305822.90018.bm@omp1002.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rkszSgfHvgV6Rg0t4+FfCD8SiZ0Rd4YLmvfcnW+dA80pRVRd8XB8afoqwl64MoQ1TiPBY3zmQWs2oI8ge705xtX7HfGjrsysZbjMSfucb6e534SS5h5qVjJ2LylRIA1gIkPe17lTX0tAVx18iAlPQqLVsMv49bC6+MjLg0vc4Ng=;
X-YMail-OSG: LaBEkIsVM1mtLkJtTFo_q8OD2j4IuAHhGQNBXDH2a.GNRce
 yK_GueqaSCWccZrUWpLnfGhTIih7cfCeskU2iNo3M_cPaJ9VichqFl0qmE7d
 jHD0gyf3oNpkUtMGqh3Sg7gOvqDDVRFpqjJe_kSt4Y9CSk7G4TqMaTmx0D5X
 xilJz_KfAasa06oqLHW_bQtWpq9i7WxEbzFcITEh2fphEmCekysLxDCBenE0
 Qa0az4U6P.An_MH31uXf4Nq7RqmPennDwuN0G5K6inUWIj317iqTO3_4eakt
 c4gUCXVwmT1hhRS7lsFO4or6lohZm1akRh8GPletPiOVWK48czZCcqTCw7Fr
 h0WtdnaIp4vn3V.oJ5jBhhxc.5VF2tc.l33yE2udY7ufr.AM.eZikYHXztXm
 GnY89ojr783llNwr_SSl04vdK2gt4MnMsUGD07pkCUbMcG1Bz9kqAGLstNy2
 F7N9m
X-Mailer: YahooMailWebService/0.8.113.313619
Message-ID: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
Date: Mon, 8 Aug 2011 23:53:06 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: running of out memory => kernel crash
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I have noticed that when the swap is disabled 

(either via swapoff or not defining any swap partition), 

then running out of memory can cause a kernel panic. 

I wonder why the hungry application won't be killed 

upon a request for a resource that is not available?
In that case, the problematic application will be killed
only but what we see now is that the whole system is
crashed.

 
// Naderan *Mahmood;
