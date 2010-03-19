Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0CSUlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:41:24 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CSUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=j+HsauURc9xXMx8wsvni/SXQZJlJHBreF1/nnAqhmpS2urUshc+6hv0nKQrXO2bpIW
         bt21nmoGSffN8srOfyU0HiuicZxhTuogOfyxtJh+soH7EslQubcyy6/A5q6deDnSnzXq
         BWCaL7kBS4mjHqzv1H4tQ0ZfX6qDBjlubuc7k=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 0/6] staging: winbond: Cleanups  
Date: Sat, 20 Mar 2010 02:10:58 +0530
Message-Id: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches are cleanups on the winbond driver
under staging. Some typedefs are converted to structs and
an un-used enumeration and a typedef are removed. 

Sankar P (6):
  staging: winbond: Convert typedef struct _PMKID to struct pmkid
  staging: winbond: Remove unused enum enum_PowerManagementMode
  staging: winbond: Convert typedef struct _STRUCT_SELECTOR
  staging: winbond: Remove typedef for standard types
  staging: winbond: Convert typedef struct _MLME_FRAME to struct
  staging: winbond: Convert typedef struct _SCAN_REQ_PARA to struct

 drivers/staging/winbond/core.h            |    2 +-
 drivers/staging/winbond/mac_structures.h  |   31 +++++++++++-----------------
 drivers/staging/winbond/mlme_s.h          |    4 +-
 drivers/staging/winbond/phy_calibration.c |    9 ++-----
 drivers/staging/winbond/scan_s.h          |    8 ++++--
 5 files changed, 23 insertions(+), 31 deletions(-)

