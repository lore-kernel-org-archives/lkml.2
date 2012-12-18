Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2LRCfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:35:19 -0500
Received: from vm-emlprdomg-04.its.yale.edu ([130.132.50.162]:33687 "EHLO
	vm-emlprdomg-04.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab2LRCfR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:35:17 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: Andreas Voellmy <andreas.voellmy@yale.edu>
In-Reply-To: <20121218020732.GA13396@dcvr.yhbt.net>
Date: Mon, 17 Dec 2012 21:35:15 -0500
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "junchang.wang@yale.edu Wang" <junchang.wang@yale.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <4854E278-265E-433E-B55E-E60DA4C300F2@yale.edu>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net> <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu> <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu> <4F40C83D-1C29-4654-8B9C-9DBFB63BDC1D@yale.edu> <20121218020732.GA13396@dcvr.yhbt.net>
To: Eric Wong <normalperson@yhbt.net>
X-Mailer: Apple Mail (2.1499)
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:130.132.50.0/24 ip4:130.132.232.0/24 include:_spf.google.com
 ?all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-18_01:2012-12-17,2012-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1212170281
X-Yale-Not-Spam: For more info see: http://www.yale.edu/email/spam/content.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17, 2012, at 9:07 PM, Eric Wong <normalperson@yhbt.net> wrote:

> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
>> There were a couple of errors in the code when I posted my last
>> message. I have fixed those. The epoll bug still occurs. 
> 
> Sorry I haven't gotten around to this.
> 
> Can you reproduce this with fewer cores? (I only have 4 at most).

I've been able to reproduce it on as few as 8 cores. I've never seen it occur with fewer than that.

> Have you tried the latest stable kernel version?

No, I've only tried 3.4.0.0.

> 
> Can you reproduce this over TCP loopback, or only across two machines?
> If the latter, it could also be a driver or firmware bug...

Yes, it also occurs when I run the http request generator on the same machine on the loopback interface.

-Andi