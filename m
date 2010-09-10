Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0IJBxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:53:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58923 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0IJBxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=t1oMV+23ZrKI9mDXs3FTIhpT0dlAF/xhs6mbNOKgymA7B50f/H3+91qA3vqDvyAgYO
         w4refUwoecwoLKHik5Yaiw5GqbvASZMYKc6r7DfkoZ5UM/0hDExbXy4HZZug43VkR3Zz
         6DD/drrrhtcfBOky+4Vpw+zuMwPFBHJmSOheU=
Date: Fri, 10 Sep 2010 09:53:10 +0800
From: "hacklu" <embedway.linux@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: how to understand powerpc's BRx ORx
Message-ID: <201009100953083354338@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

         I didn't understand the address mask.
it's said that: BR[BA] is the base address,the OR[AM] is the  address mask,
"Provides masking for corresponding BRx bits. By masking address 
bits independently, SDRAM devices of different size address ranges can be used. Clearing 
bits masks the corresponding address bit. Setting bits causes the corresponding address 
bit to be compared with the address pins. Address mask bits can be set or cleared in any 
order, allowing a resource to reside in more than one area of the address map. SDAM can 
be read or written at any time."

how to understand it?
for instance, if my BR0[BA]=0111_0000_0000_0000_0, OR0[AM]=1111_1111_1111
if I want to access the 0x70000000 or the 0x71000001.what address calculate will be taken?

thanks all
 				
--------------
hacklu
2010-09-10

