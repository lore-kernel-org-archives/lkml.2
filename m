Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab0JZO2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:28:37 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:54191 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:28:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010260074
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-26_07:2010-10-26,2010-10-26,1970-01-01 signatures=0
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: #ifdef CONFIG_ checks not working
Date: Tue, 26 Oct 2010 18:28:22 +0400
Message-id: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luciano Coelho <luciano.coelho@nokia.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       I just noticed that with the 2.6.36-rc8 kernel, the #ifdef checks aren't working. 

So for example, if I add the following code fragment in my omap3_beagle_init function, CONFIG_WL1271 doesn't get detected, even though in my .config file, CONFIG_WL1271=m.

This way, the mux settings might also fail, right, which might be the source of a few of the problems that I'm facing. 

Would you happen to know why this is not working. This type of checks used to work with the 2.6.32 kernel versions.

#ifdef CONFIG_WL1271
    printk(KERN_INFO "%s: CONFIG_WL1271 detected\n", __func__);
#else
    printk(KERN_INFO "%s: CONFIG_WL1271 not detected\n", __func__);
#endif

Boot message: 

[    0.000000] omap3_beagle_init: CONFIG_WL1271 not detected

Best regards,

Elvis Dowson

