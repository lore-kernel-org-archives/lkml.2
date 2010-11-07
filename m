Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0KGIi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:38:29 -0500
Received: from asmtpout029.mac.com ([17.148.16.104]:52657 "EHLO
	asmtpout029.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0KGIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:38:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1011070010
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-07_02:2010-11-05,2010-11-07,1970-01-01 signatures=0
Subject: Re: Forked android kernel development from linux kernel mainline
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <20101106181202.GA6927@kroah.com>
Date: Sun, 07 Nov 2010 12:38:07 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
 <20101106181202.GA6927@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Greg,

On Nov 6, 2010, at 10:12 PM, Greg KH wrote:

> Are you willing to maintain the android kernel code in the mainline
> kernel tree?  If so, I will be glad to add it back in, but as no one was
> willing to do the work, it was removed.  It's as simple as that.

I'm willing to do this. I'll start off initially with support for TI OMAP 35xx
and TI OMAP 4440, build and test initially on the Gumstix Overo,
BeagleBoard and PandaBoard. 

I'll start with v2.6.37-rc1 and android-froyo-2.2, and try to do the required
changes to get it accepted into mainline by v2.6.39.

Elvis Dowson

