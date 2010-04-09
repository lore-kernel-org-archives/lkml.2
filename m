Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0DILcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:32:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55129 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0DILb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jmWCvZnnF9DqG7LA9bt/uE8+U7V261afdQwTJpu4esvF0dzPrh6iHuqPUd2QdhkAcj
         bEHxpNIND0qdloALzGNLHyx2u5F+xTarpnvSBW0WTDqkPP965ETaJtG178+vF1cw8bFR
         o3WCWFOBfBABC2W6yhX0K2R52298XL/NUfCac=
MIME-Version: 1.0
Date: Fri, 9 Apr 2010 17:01:58 +0530
Message-ID: <j2k241b8f7b1004090431r8a83ad66y7704e679ab79812b@mail.gmail.com>
Subject: Writing to NAND, Which is not visible to USER
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  I want to write someting to the NAND flash, which is not a part of
partitioning.

say , out of 128 MB , I am using 64 MB which I have partitioned using
MTD, but I have to access the other  64 MB.

Can any one help me or give me any ideas ?

Is it possible to write using assmbly code. I am using MIPS board.


Thanks In advance !!!
Prabhu
