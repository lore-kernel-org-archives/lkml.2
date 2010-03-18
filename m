Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0CRWIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:40 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34555 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0CRWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qJRAepxMj7/kQW2chy+ty31RCEePiD5LppqwTeSFzU6PEF0muef+APWwLZx3hjFTnr
         AHG0k4LH+0k9DnGUZCGYV/ukfH1FpqS3RWlTGWBMshHNX2vFC3B+XZho9iIez2ASw7Vm
         rwC+CpGRksTwEQjrr/p18HilPFAaicBcHY4+4=
Message-ID: <4BA2A45B.6060004@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:27 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] arch/x86/kernel/head_32.S Warning: shift count out of
 range (32 is not between 0 and 31)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..8bfba5e 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -62,7 +62,7 @@

  /* Enough space to fit pagetables for the low memory linear map */
  MAPPING_BEYOND_END = \
-	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
+	PAGE_TABLE_SIZE(((1<<31) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT

  /*
   * Worst-case size of the kernel mapping we need to make:
