Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0EFFrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 01:47:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50737 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0EFFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 01:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bBwxqYudj78jQcvs2xCHRs7fciv1LLtvNNgNpPH14CDw/GaOFTDmXLJlnRx9l+mHut
         p6edSrWeydOAKuPcc3fAqJSMUAl52+sZIhwS6IyHoB3vZQKKNpGJgen3GMJ8zYRq6PQ0
         2PCZ+z/EJofHua+U+PxgVWtkj+InHS7SGywPU=
Message-ID: <4BE257EF.9050904@gmail.com>
Date: Thu, 06 May 2010 08:47:27 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: stable@kernel.org
Subject: nfs kernel server causes: kernel BUG at include/linux/module.h:386!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after some nfs server start/stop i hit kernel bug on 2.6.26. There is hope[1] 
that this bug is fixed[2], and fix is merged[3] into 2.6.29. But there is 
missing bugfix for older stable kernels.

Reports for this bug can also be found on distro bug systems[4][5][6][7]. 
Sadly these bugs are still open.

Please backport fix for stable kernels too.

roma1390

1. http://linux-nfs.org/pipermail/nfsv4/2009-March/010018.html
2. 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22945e4a1c7454c97f5d8aee1ef526c83fef3223
3. 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=713404d6082fee34a829a0c6d511e4aec72d7654
4. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=516376
5. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=519348
6. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=532561
7. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=538000

