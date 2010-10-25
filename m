Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0JYTzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:55:10 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:35009 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab0JYTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:55:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010250125
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-25_08:2010-10-25,2010-10-25,1970-01-01 signatures=0
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: How to prevent + being appended to kernel image name
Date: Mon, 25 Oct 2010 23:54:44 +0400
Message-id: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       When I build the linux-2.6.36 kernel (wl12xx wireless repo) using OpenEmbedded (OE), the kernel image that gets created has the name "Linux-2.6.36-rc8-wl"

However, when I build it from within TI CCS v5 (eclipse IDE), the resulting kernel image name has a + sign appended to the image name "Linux-2.6.36-rc8-wl+"

How can I prevent the + symbol from being prefixed to the kernel image name? 

I'm using OE to build the rootfilesystem and the kernel driver modules, but using TI CCS v5 to incrementally modify my board definition file, and quickly compile the kernel and test it. Because of the + prefix, I'm unable to load kernel modules correctly due to the mismatch in the kernel image names.

Elvis Dowson




