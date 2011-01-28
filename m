Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1A1W7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:59:15 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:44871 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1A1W7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:59:12 -0500
Subject: [PATCH] [TRIVIAL] Fix printk typo 'failled'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Jan 2011 23:32:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1296253970.4019.4.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/evergreen.c   |    2 +-
 drivers/gpu/drm/radeon/r100.c        |    8 ++++----
 drivers/gpu/drm/radeon/r300.c        |    4 ++--
 drivers/gpu/drm/radeon/r420.c        |    4 ++--
 drivers/gpu/drm/radeon/r520.c        |    4 ++--
 drivers/gpu/drm/radeon/r600.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c |    2 +-
 drivers/gpu/drm/radeon/rs400.c       |    4 ++--
 drivers/gpu/drm/radeon/rs600.c       |    4 ++--
 drivers/gpu/drm/radeon/rs690.c       |    4 ++--
 drivers/gpu/drm/radeon/rv515.c       |    4 ++--
 drivers/gpu/drm/radeon/rv770.c       |    2 +-
 12 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7fe8ebd..bde4147 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2952,7 +2952,7 @@ int evergreen_resume(struct radeon_device *rdev)
 
 	r = r600_ib_test(rdev);
 	if (r) {
-		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+		DRM_ERROR("radeon: failed testing IB (%d).\n", r);
 		return r;
 	}
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f637595..57faec9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3603,13 +3603,13 @@ int r100_ib_init(struct radeon_device *rdev)
 
 	r = radeon_ib_pool_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB pool (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB pool (%d).\n", r);
 		r100_ib_fini(rdev);
 		return r;
 	}
 	r = r100_ib_test(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled testing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed testing IB (%d).\n", r);
 		r100_ib_fini(rdev);
 		return r;
 	}
@@ -3767,12 +3767,12 @@ static int r100_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index fae5e70..a83d174 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1357,12 +1357,12 @@ static int r300_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index c387346..29998e2 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -260,13 +260,13 @@ static int r420_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r420_cp_errata_init(rdev);
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 3c8677f..3e85628 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -193,12 +193,12 @@ static int r520_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 6b50716..d4821e0 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2467,7 +2467,7 @@ int r600_resume(struct radeon_device *rdev)
 
 	r = r600_ib_test(rdev);
 	if (r) {
-		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+		DRM_ERROR("radeon: failed testing IB (%d).\n", r);
 		return r;
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 06e7982..239c3d7 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -151,7 +151,7 @@ int radeon_ib_schedule(struct radeon_device *rdev, struct radeon_ib *ib)
 	/* 64 dwords should be enough for fence too */
 	r = radeon_ring_lock(rdev, 64);
 	if (r) {
-		DRM_ERROR("radeon: scheduling IB failled (%d).\n", r);
+		DRM_ERROR("radeon: scheduling IB failed (%d).\n", r);
 		return r;
 	}
 	radeon_ring_ib_execute(rdev, ib);
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 5512e4e..7080ee2 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -409,12 +409,12 @@ static int rs400_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index b4192ac..e92f320 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -866,12 +866,12 @@ static int rs600_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 0137d3e..2e72b4f 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -628,12 +628,12 @@ static int rs690_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 5d569f4..a5a4e2e 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -398,12 +398,12 @@ static int rv515_startup(struct radeon_device *rdev)
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing CP (%d).\n", r);
 		return r;
 	}
 	r = r100_ib_init(rdev);
 	if (r) {
-		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		dev_err(rdev->dev, "failed initializing IB (%d).\n", r);
 		return r;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 3a264aa..f0b8814 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1201,7 +1201,7 @@ int rv770_resume(struct radeon_device *rdev)
 
 	r = r600_ib_test(rdev);
 	if (r) {
-		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+		DRM_ERROR("radeon: failed testing IB (%d).\n", r);
 		return r;
 	}
 
-- 
1.7.3.5



