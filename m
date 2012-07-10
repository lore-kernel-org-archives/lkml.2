Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2GJBfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:35:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42403 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJBfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:35:50 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com, dan.carpenter@oracle.com, standby24x7@gmail.com,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/3] staging: bcm: Cleanup bcm driver
Date: Mon,  9 Jul 2012 22:32:37 -0300
Message-Id: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kernel guys!
   
This new patchset tries to clean a little the bcm driver, removing
some unused macros and some dead code.
  
These macros and dead code were reported by the forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).
  
The tool is under development, but all the patches looks like OK.       
                               
This patchset is based in staging-next.
  
Thanks guys!

Marcos Paulo de Souza (3):
  staging: bcm: Remove code that will never execute
  staging: bcm: Remove all commented macros
  staging: bcm: Misc.c: Remove unused macros

 drivers/staging/bcm/CmHost.c     |    1 -
 drivers/staging/bcm/Debug.h      |    5 ---
 drivers/staging/bcm/Macros.h     |    1 -
 drivers/staging/bcm/Misc.c       |   66 --------------------------------------
 drivers/staging/bcm/PHSDefines.h |    1 -
 5 files changed, 74 deletions(-)

-- 
1.7.10.4

