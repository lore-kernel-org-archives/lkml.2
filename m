Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0C2P7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:59:19 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:33989 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0C2P7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LVCuzbKuIsWeDaGjLmoPmxfLA61RFM+UAf2Mj0xidynqIZQlI34ppCGSmQfWaXVFq4
         mhuFxrgtVyO7nWxs0Ik6kzw9KpXnk8FVFuFDOoxRu78yTxGRx4R631s6ixKi57mEguXy
         f6Dcyb8zeBlDkVQ5gja7eZWRjPWOB4Uln9qxs=
Message-ID: <4BB0CE4C.40306@googlemail.com>
Date: Mon, 29 Mar 2010 17:59:08 +0200
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.2pre) Gecko/20100302 Lanikai/3.1b1
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-kernel@vger.kernel.org
Subject: [BUG] No SPROM available!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

since commit fcb54b0bf7d3fe730c2b72e224bc616e358f24cb, my b43 (4312) 
device doesn't work.

But the device have a sprom. Maybe the chip-status register check is wrong?

+/** Macros to determine SPROM presence based on Chip-Status register. */
+#define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
+       ((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+               SSB_CHIPCO_CHST_4325_OTP_SEL)
