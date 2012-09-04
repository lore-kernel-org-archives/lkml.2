Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2IDJSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:18:08 -0400
Received: from ocse.iitkgp.ernet.in ([203.110.246.9]:33853 "EHLO
	ocse.iitkgp.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab2IDJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:18:06 -0400
X-TM-IMSS-Message-ID: <d1ae8ea9000784d1@WIN-EY2RUGWN1EN>
Date: Tue, 4 Sep 2012 14:40:08 +0530 (IST)
From: Sachin Agarwalla <sachin.agarwalla@cse.iitkgp.ernet.in>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1283617617.10114.1346749808002.JavaMail.root@mailstore2.iitkgp.ac.in>
In-Reply-To: <5045A6C9.8000101@gmail.com>
Subject: Re: need help on development of linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.100.244]
X-Mailer: Zimbra 6.0.7_GA_2470.RHEL5_64 (ZimbraWebClient - SAF3 (Linux)/6.0.7_GA_2470.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir/Madam,
 Thank you for your support.I want to know is the linux kernel cpu scheduling part optimized for scalable multi core architecture.If not then what are the scope if improvements?Can you help me?

thanking you,
waiting for your reply,
yours faithfully,
sachinagarwalla

----- Original Message -----
From: "Cong Wang" <xiyou.wangcong@gmail.com>
To: "Sachin Agarwalla" <sachin.agarwalla@cse.iitkgp.ernet.in>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Sent: Tuesday, September 4, 2012 12:29:21 PM
Subject: Re: need help on development of linux kernel

On 08/30/2012 12:15 PM, Sachin Agarwalla wrote:
> Dear Sir/Madam,
>    I have some questions on development of linux kernel as follows:-
> 1.I want to know the location of files in linux kernel source code that contains timer initialization and scheduler part.

Scheduler source code is in kernel/sched/* files.

> 2.Also I want to know location of header files(or library files) that are present in the above files.

include/linux/sched.h

> 3.Is there any version of linux kernel that uses openmp or inteltbb or parallelc tool.

No, kernel doesn't use any libraries including libc.

