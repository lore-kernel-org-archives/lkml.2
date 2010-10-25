Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0JYU0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:26:38 -0400
Received: from asmtpout025.mac.com ([17.148.16.100]:40058 "EHLO
	asmtpout025.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab0JYU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:26:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010250127
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-25_08:2010-10-25,2010-10-25,1970-01-01 signatures=0
Subject: Re: How to prevent + being appended to kernel image name
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
Date: Tue, 26 Oct 2010 00:26:20 +0400
Message-id: <28DC96E3-C6A9-4D5D-984F-C11EB7E932FC@mac.com>
References: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Oct 25, 2010, at 11:54 PM, Elvis Dowson wrote:

> How can I prevent the + symbol from being prefixed to the kernel image name? 

I found the solution. You can disable the plus sign is the LOCALVERSION environment variable or make variable:

make LOCALVERSION= all

make ARCH=arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- LOCALVERSION=  -j6 uImage

Elvis Dowson
