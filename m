Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0IGGhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:37:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55524 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0IGGhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=adgmYGtghbGxicMe/glKtn2X4qi/3cVjC0rLe3BqseX9LRecRel8JhAF3efwICX5/v
         DdEOmqm4AtQZYLP8CRm7nrdGnYjlrlLvJOHrLEIAp7Lm0/alC+sx17mrLyvP0Ec4TOK6
         vAfN3ioNQ90pU8wI8RIdtza3oNi6kOyzWh6OA=
MIME-Version: 1.0
In-Reply-To: <AANLkTim=JEuHBXXqVFOJ4ozXGSEVxjuCt7sOpXcox-NQ@mail.gmail.com>
References: <AANLkTim=JEuHBXXqVFOJ4ozXGSEVxjuCt7sOpXcox-NQ@mail.gmail.com>
Date: Tue, 7 Sep 2010 14:37:41 +0800
Message-ID: <AANLkTikyM=XmFp2RSQtiHpoF3gVZKyEfpDFg2_Cd_ssW@mail.gmail.com>
Subject: Fwd: anyone can help me about nand_get_flash_type
From: Tony Wan <visual2me@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone can help me with this problem? even some ideas how to debug and
find the problem? Thank you!


---------- Forwarded message ----------
From: Tony Wan <visual2me@gmail.com>
Date: Wed, Aug 25, 2010 at 5:36 PM
Subject: anyone can help me about nand_get_flash_type
To: linux-mtd@lists.infradead.org


Hi there,

I got an ARM device from Marvell with a NAND rom, running Linux
2.6.22.18. These days I'm working on upgrading the kernel to 2.6.31.8.
After the upgrade, all devices work well except the NAND rom. I found
it's because that the device and manufacturer IDs cannot be retrieved
correctly in nand_get_flash_type.  In 2.6.22.18, the IDs can be
retrieved as expected; but in 2.6.31.8, the IDs always be 0, which
leads to an error in nand_scan.

I'm a definitely newbie with MTD, and currently have no idea about the
problem. Except IO_ADDR_R & IO_ADDR_W are remapped to different
addresses, I can't find any differences between the 2 versions from
the system log -- may it be the reason? Anyone can give me some tips
about this problem -- how to fix it or how to debug? Any suggestions
will be appreciated.

--
Best regards,
Tony Wan



-- 
Best regards,
Tony Wan
