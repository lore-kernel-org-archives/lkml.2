Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2FLJhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:37:43 -0400
Received: from nm17.bullet.mail.sp2.yahoo.com ([98.139.91.87]:40813 "HELO
	nm17.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448Ab2FLJhm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:37:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 830666.19562.bm@omp1031.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=btSYSxTQRYZLlhx/gItl3dasLHOsFg3tuF1YCtbH5n0JJ2C0y8TvZR4vg7sylc7iN4k6H4koThjNfXWll291tMP5hxzpd91QBl6OWURYVTBHed0oBKJ6x7tzljVbz4XlMhFs9KxheCylZnbYJP5yQiT+7cATPCrs5HI/Nc1nAug=;
X-YMail-OSG: i3jZxPUVM1n9h5JdAO.Q3h1EzfD2_dVXa4LG14_xphq_hJ6
 I6w5JAtX_7qgHu7VXZUE7sTfBGoTlAX5Sw1Gau3PuxdbygqMrNMkyDvajDy7
 3L2zw56yng.TVvL8Hh4x76u1ME4BKZfYL4CbLE9YK7V2EAt96tDkqVsnHbP7
 eNGULb6wIIV088e6YnJPdtL0CB0VgXbxAEiKQYIHn3oK9eJqHPffMhF8_d05
 ORdWtG8asbrisvw27JlkvI4dCKnYHKL5oz4KEJmLhCfQ_NkKdaXNztyHydCL
 7mKf3DmgGzBvMgwayMB0Ez5KeBk_rk1K_DozFtSOKzukJA0FAo0wGYatlNFy
 oGlb3QI5a2Ne6CtGoFheg50nOOj3yQL7pcAngG_wqi60J3r92Uh4Aelz5O6a
 pzpKS.PoQzgJJBJaXcmL0UERGW278cQE_HsmgY8OF9gtg4DTYdm3KzN2yemj
 yXDXaoYmzrsnUNwPE0YvTcMir
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
Date: Tue, 12 Jun 2012 02:37:40 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: CPU MTRRs and linux kernel
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
Abour rhis warnning in boot log:

WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB of RAM

 
I
 searched a lot however didn't find a clear solution. Does AMD new 
processors (62XX) have problems with new kernels or old kernels??
Mine is:

Linux n1 2.6.32-24-server #39-Ubuntu SMP Wed Jul 28 06:21:40 UTC 2010 x86_64 GNU/Linux

Should I upgrade?


~MN
