Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0GWHiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:38:19 -0400
Received: from [61.177.137.56] ([61.177.137.56]:28964 "HELO mail.semico.com.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752827Ab0GWHiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:38:18 -0400
Message-ID: <006401cb2a3a$2cf95a80$3701a8c0@wxintech.com>
From: "zhanglx" <zhanglx@semico.com.cn>
To: "zhanglx" <zhanglx@semico.com.cn>, <linux-kernel@vger.kernel.org>
Subject: Re: Question about net subsystem
Date: Fri, 23 Jul 2010 15:39:25 +0800
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-RFC2646: Format=Flowed; Original
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a doc of LinuxIPNetworking on kernelnewbies.org. It describes 
networking in detail.

thanks,
zhanglx
----- Original Message ----- 
From: "zhanglx" <zhanglx@semico.com.cn>
To: "zhanglx" <zhanglx@semico.com.cn>; <linux-kernel@vger.kernel.org>
Sent: Thursday, July 22, 2010 9:21 AM
Subject: Question about net subsystem


> hello,
>
> I have some questions about net subsystem.
>
> Does the kernel code store the IP address of local machine, in which 
> variable?
>
> If there are two net cards, then there will be two IP and MAC address, how 
> will the kernel store them? When there are two net cards, which card will 
> the PC use to connect to net.
>
> Does the webbrowser such as Firefox also use the series of functions( 
> sock(), connect(), send(),receive()...) to connect to internet?
>
> Thanks,
> zhanglx 


