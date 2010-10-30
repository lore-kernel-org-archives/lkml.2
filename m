Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0J3STL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:19:11 -0400
Received: from asmtpout024.mac.com ([17.148.16.99]:49099 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0J3STJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:19:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-30_07:2010-10-29,2010-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010300103
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: Forked android kernel development from linux kernel mainline
Date: Sat, 30 Oct 2010 22:18:37 +0400
Message-id: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       I was wondering what the long term implications of android development being forked from the linux mainline are? 

Android support was removed from 2.6.33 onwards, and development still continues for 2.6.35, by reverting the commit that deleted android from the mainline.

One could argue that android gave linux a solid boost widespread adoption for mobile embedded devices, and its use would continue to grow exponentially with time, more than plain vanilla linux for embedded devices. 

Was removing android from the linux kernel mainline a mistake, in retrospect?

Best regards,

Elvis Dowson

