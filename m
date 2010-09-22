Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0IVDUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:20:23 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25536 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0IVDUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:20:22 -0400
Subject: [PATCH v2 0/2] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        dri-devel@lists.freedesktop.org, Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <1285023750.30856.99.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 23:20:10 -0400
Message-ID: <1285125610.2518.19.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_02:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009210245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Greg's request, here is a resend of my previous patch to add sysfs
entries to allow manual override of DRM KMS connector polling actions,
with accompanying documentation.

Only documentation has been added.
No code has changed from the previous patch submission.

diffstat:

Documentation/ABI/testing/sysfs-drm |  208 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_sysfs.c         |   69 +++++++++++
 2 files changed, 277 insertions(+)

Regards,
Andy 

