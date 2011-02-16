Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1BPIrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:47:46 -0500
Received: from web161610.mail.bf1.yahoo.com ([98.139.210.179]:29320 "HELO
	web161610.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753046Ab1BPIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:47:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=YcLs5huHGT0h7pYbj0R/pEAPIq4wdTcTDIsosrGWPHSEcRnXbB26I5Ksw9KSXLDO2ym8ff9fy2CZHH1LICyxDfCLWPkrwr/724q/05BGvm0GBmB2/p5Dg0sI7k2+oojffQABtEg0uTM3NEZPAwFGyc4DSg7yI725lH4YnN+wzSU=;
Message-ID: <278203.57199.qm@web161610.mail.bf1.yahoo.com>
X-YMail-OSG: LtDVfPsVM1mvsze.t3xmQMmV4iHI2Y_KNqSnDdGtVqPyvNP
 8DvZdZNgTv3z6oTr9ozLreKjdPuqtwby6evkbWr6ChOSJrpbQN_0dAN4hSgk
 VgTIly.C_wyW4cVnDb93qnBOJ9bASnCM5EgbQmU73tiYC8i8CnJkEy_REpyg
 5ohAeMNwYggKyhb7bIx58zedKCYVT6IRkczKG0I8e491MIlL3xguqpvquTs8
 xq4xjH4uABInYdMxE1HdIMrGNzi4m90YqVC02nk6_8Vxg7QV1WHmFBnW8_CQ
 aHqDgDBencgyvy6Ss3c6p3cHeJQ--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.292656
Date: Wed, 16 Feb 2011 00:47:43 -0800 (PST)
From: satu dua <amuro_msg@yahoo.com>
Subject: kernel oops in vmalloc code
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel oops while unmounting xfs.

here's the link on bugzilla :

https://bugzilla.kernel.org/show_bug.cgi?id=27002


      
