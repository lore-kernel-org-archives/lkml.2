Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1HJRtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:49:47 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:58058 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab1HJRtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:49:46 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-fb-4e42c44b9067
Message-ID: <4E42C4B5.7010201@mit.edu>
Date: Wed, 10 Aug 2011 13:49:41 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sreeram B S <sreeramb@netapp.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: UDP requires 2 reads to obtain vital information - Kindly comment
References: <4E42B886.4030607@netapp.com>
In-Reply-To: <4E42B886.4030607@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsUixG6nout9xMnPYM9xI4vLu+awWVzre8zq
	wOQx49MXNo/Pm+QCmKK4bFJSczLLUov07RK4MjZ//MVasIetYs22i4wNjJNZuxg5OSQETCTO
	H3vNBmGLSVy4tx7I5uIQEtjHKLF75T8WkISQwAZGidMX7SESF5gkWrtaGEESvAJqEs/2zwCb
	xCKgKnH59VuwOJuAikTH0gdMILaoQJDE/d8NLBD1ghInZz4Bsjk4RIDqr/9NBwkzCyhIdD2b
	BtYqLOAnsWjaQmaIvZoS1/Z8ARvDKaAlMf3FS7BWZgFriW+7iyBa5SW2v53DPIFRcBaSBbMQ
	qmYhqVrAyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI11gvN7NELzWldBMjKHA5Jfl2MH49qHSI
	UYCDUYmHl2m1k58Qa2JZcWXuIUZJDiYlUV6bw0AhvqT8lMqMxOKM+KLSnNTiQ4wSHMxKIrxS
	84ByvCmJlVWpRfkwKWkOFiVx3tU7HPyEBNITS1KzU1MLUotgsjIcHEoSvLrACBUSLEpNT61I
	y8wpQUgzcXCCDOcBGq4MUsNbXJCYW5yZDpE/xagoJc7rB3KRAEgiozQPrheWWF4xigO9Isyr
	AtLOA0xKcN2vgAYzAQ2uv+MAMrgkESEl1cA49/b17HfbxXTnXVSL0Z/4S3nridwPynrnDG6K
	T3c3yUtM6DJ/yDg5g8u7r+On/G/RPL/qUxUGl1Y5etZyeSTxCJuJTFvMc9RudUT3+Qnfqqpe
	f9I89e5ecJ25iuuPSXoxs56dn6lg0c+/RDrlgtPFrxEC2bnPVIP42iOz2YxPtOnf1dxrwKXE
	UpyRaKjFXFScCABQOAZNBwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 12:57 PM, Sreeram B S wrote:
> Respected people,
> I am Sreeram. I work on TCP/IP network applications.
> This mail is regarding UDP.
> Whenever a UDP datagram arrives, the receiver may wish to know the
> sender's IP address and also the destination address of that datagram.
> The recvfrom() function will return the sender's IP address. If the
> destination address of the datagram is required, then the user has to
> set the IP_PKTINFO socket option for the UDP socket and get the
> address as ancillary data in recvmsg(). So, the point here is that the
> user has to issue 2 reads on the same datagram (with the flag MSG_PEEK
> in first read call enabled) in order to obtain the sender's IP and the
> destination IP of the datagram.

Does the msg_name field of struct msghdr not work?

--Andy
