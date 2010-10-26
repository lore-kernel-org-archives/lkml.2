Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab0JZOgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:36:09 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:35036 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab0JZOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:36:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010260076
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-26_07:2010-10-26,2010-10-26,1970-01-01 signatures=0
Subject: Re: #ifdef CONFIG_ checks not working
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
Date: Tue, 26 Oct 2010 18:35:54 +0400
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Message-id: <DAE6C7A6-D074-45D1-8966-378FB98B97F7@mac.com>
References: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26, 2010, at 6:28 PM, Elvis Dowson wrote:

> I just noticed that with the 2.6.36-rc8 kernel, the #ifdef checks aren't working. 
> 
> So for example, if I add the following code fragment in my omap3_beagle_init function, CONFIG_WL1271 doesn't get detected, even though in my .config file, CONFIG_WL1271=m.

Ok, I guess its because should have been CONFIG_WL1271=y.

Best regards,

Elvis

