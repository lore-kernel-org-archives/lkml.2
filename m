Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0HHLWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 07:22:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58519 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0HHLWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 07:22:19 -0400
Message-ID: <4C5E9365.5030804@in.ibm.com>
Date: Sun, 08 Aug 2010 16:52:13 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        christof.schmitt@de.ibm.com, swen@vnet.ibm.com
Subject: 2.6.35-git6: s390 build failure (drivers/s390/scsi/zfcp_qdio.c)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest 2.6.35 git - 2.6.35-git6 (cd816a0d8...) fails to build
on a s390 box with following error :

drivers/s390/scsi/zfcp_erp.c: In function 'zfcp_erp_thread':
drivers/s390/scsi/zfcp_erp.c:1337: warning: frame size of 'zfcp_erp_thread' is 280 bytes
drivers/s390/scsi/zfcp_qdio.c: In function 'zfcp_qdio_siosl':
drivers/s390/scsi/zfcp_qdio.c:467: error: implicit declaration of function 'ccw_device_siosl'
make[2]: *** [drivers/s390/scsi/zfcp_qdio.o] Error 1

This problem seem to have been introduced with git2 (3cfc2c42c1c...) via
commit 339f4f4eab80caa6cf0d39fb057ad6ddb84ba91e

[SCSI] zfcp: Trigger logging in the FCP channel on qdio error conditions

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

