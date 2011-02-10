Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1BJCwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:52:01 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:44665 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1BJCwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:52:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=TjInZkJNhVTxJg2qY8NE+RVmnNE3EWj7bFyv78On1vuuy5QGTCtP2FIiOXTFqfhBm6
         Vh4fobE0++5jd7MSC7+NzUN7yVmJvFCkHR8+euxWjNHLjA2Ofitt2gXsocHZfGGWHhh+
         MjDu8/bIQmAUdHxGVp3a7+a4wM9RWaNUluIVg=
Date: Thu, 10 Feb 2011 10:51:35 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com, rdunlap@xenotime.net
Subject: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
Message-ID: <20110210025133.GA3285@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, davem@davemloft.net, greg@kroah.com,
	rdunlap@xenotime.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
    When i see MAITAINERS, i find an inconsistent double-quotation-marks.
So i patch for it:) patcher like following.

Thanks.
Best Regards.
Harry Wei.


Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index afb6f7c..95ac55c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -139,7 +139,7 @@ S:	Supported
 F:	drivers/scsi/3w-*
 
 53C700 AND 53C700-66 SCSI DRIVER
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
+M:	James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/53c700*
-- 
1.7.0.4

