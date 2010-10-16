Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0JPUnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:43:42 -0400
Received: from asmtpout030.mac.com ([17.148.16.105]:52775 "EHLO
	asmtpout030.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JPUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:43:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010160117
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-16_07:2010-10-15,2010-10-16,1970-01-01 signatures=0
Subject: Re: Alternate git repo servers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CBA0D1C.6000805@example.com>
Date: Sun, 17 Oct 2010 00:43:00 +0400
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <52F86985-723A-40BB-9C3E-2CC11A49BD2A@mac.com>
References: <2D81AEF9-2724-4187-8D69-1C1282ADBCC9@mac.com>
 <7B26AF36-809D-4044-AC14-0CB7985E2D50@mac.com> <4CBA0D1C.6000805@example.com>
To: piotr@hosowicz.com
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Oct 17, 2010, at 12:37 AM, Piotr Hosowicz wrote:

> 
>> I just tried switching protocols from git to http,
> 
> How did you do it? Just replaced git:// with http:// ?

Yes, just type 

git clone http://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git

Are you also experiencing slowness with the git protocol with the servers on git.kernel.org & gitorious.org. It has slowed down to a crawl to a point that it is completely un-usable. 

Ubuntu 10.04 tends to give EOF errors, while Mac OS X 10.6.4 tries to keep downloading at a low speed of around 20KiB/s, but doesn't terminate that easily. I've been experiencing this for over 2 days now, and it suddenly occurred that I should try an alternate protocol. I was expecting much less, but to my surprise, http protocol was working as fast as the native git protocol while downloading from these servers. 

Elvis Dowson
