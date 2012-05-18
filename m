Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946606Ab2ERXFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946588Ab2ERXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:45 -0400
Message-Id: <20120518212649.964554183@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:26:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 08/47] media: marvell-cam: fix an ARM build error
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Corbet <corbet@lwn.net>

commit 9967232f1be5bab10c7b7a8dcf51ff5c3c1a6d77 upstream.

One of the OLPC changes lost a little in its translation to mainline,
leading to build errors on the ARM architecture.  Remove the offending
line, and all will be well.

Reported-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/marvell-ccic/mmp-driver.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -176,7 +176,6 @@ static int mmpcam_probe(struct platform_
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
-	mcam->platform = MHP_Armada610;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->dev = &pdev->dev;


