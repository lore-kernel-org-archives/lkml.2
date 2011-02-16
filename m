Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab1BPK2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 05:28:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58407 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab1BPK2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 05:28:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ChrBdVdYXAa7cdZjNJsfqU3QdE7IoLvliFmA3/WXKeR0gyFmwaRtL6hZn/1/GISI28
         ieA2qW8wpEsQyCxtwqz3lrul0Vvx/Im0lkkRwjhGhzyvGJPOcll2pgHd2OQAwdmrWOwJ
         oC/5zJboKSVtJ1NTHfCNVezJ3qtHGxjphlHa8=
Date: Wed, 16 Feb 2011 18:28:18 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net,
        greg@kroah.com, rdunlap@xenotime.net
Subject: [PATCH]Maintain Chinese Documentations
Message-ID: <20110216102801.GA10961@gmail.com>
Mail-Followup-To: trivial@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net,
	greg@kroah.com, rdunlap@xenotime.net
References: <iiqti3$3b5$2@dough.gmane.org>
 <AANLkTinGn5oN01+33VgnnWHAqEZNxkoJeTgkjAjpC8LZ@mail.gmail.com>
 <20110208093020.GA2016@gmail.com>
 <20110208093528.GA2580@pengutronix.de>
 <AANLkTi=RgPS_tzBP+0=wxuh58cV=3_m+5=gYwG8ffkY0@mail.gmail.com>
 <20110208100153.GA2815@gmail.com>
 <20110208101328.GB2580@pengutronix.de>
 <AANLkTimSgeRKsAckU+2iE9oqo33uanLeLaKTQdYkpfw=@mail.gmail.com>
 <20110208103332.GA2932@gmail.com>
 <AANLkTimAAq10AzoWFBhKKSizH5pX_F8jOPsQE25w9J_E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimAAq10AzoWFBhKKSizH5pX_F8jOPsQE25w9J_E@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
	I have translated some documentations of kernel so i want to maintain Chinese documentation in our kernel directories.
	Following is my patch for it.
	       
	Thanks.
	Best Regards.
	Harry Wei.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc0279e..afb6f7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1692,6 +1692,12 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
+CHINESE DOCUMENTATION
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+L:	linux-kernel@zh-kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/zh_CN/
+
 CISCO VIC ETHERNET NIC DRIVER
 M:	Vasanthy Kolluri <vkolluri@cisco.com>
 M:	Roopa Prabhu <roprabhu@cisco.com>
-- 
1.7.0.4

