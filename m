Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0JPU01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:26:27 -0400
Received: from asmtpout030.mac.com ([17.148.16.105]:36610 "EHLO
	asmtpout030.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0JPU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:26:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010160114
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-16_07:2010-10-15,2010-10-16,1970-01-01 signatures=0
Subject: Re: Alternate git repo servers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <2D81AEF9-2724-4187-8D69-1C1282ADBCC9@mac.com>
Date: Sun, 17 Oct 2010 00:25:44 +0400
Message-id: <7B26AF36-809D-4044-AC14-0CB7985E2D50@mac.com>
References: <2D81AEF9-2724-4187-8D69-1C1282ADBCC9@mac.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Oct 16, 2010, at 11:57 PM, Elvis Dowson wrote:

> Are there any alternate git servers for the following repos, the existing one are very slow for me (at 20kbps), while I have an 8MBps downlink speed.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git 

I just tried switching protocols from git to http, and http works with a 938KiB/s download rate, compared to 20KiB/s using the git protocol. 

Kinda of the opposite of what one would expect. 

Elvis Dowson
