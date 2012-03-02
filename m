Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2CBIuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:50:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2CBIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:50:50 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.57+drm33.23
Date: Fri,  2 Mar 2012 09:50:46 +0100
Message-Id: <1330678246-11403-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.57+drm33.23 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/i915: Fix TV Out refresh rate.
* Linux 2.6.32.57+drm33.23

 Makefile                        |    2 +-
 drivers/gpu/drm/i915/intel_tv.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 6ecde40..f0bb72a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .57+drm33.22
+EXTRAVERSION = .57+drm33.23
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 552ec11..ae64f9d 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -415,7 +415,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 3.580MHz */
@@ -458,7 +458,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-443",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 4.43MHz */
@@ -500,7 +500,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-J",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -543,7 +543,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "PAL-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -587,7 +587,7 @@ static const struct tv_mode tv_modes[] = {
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL-N",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -632,7 +632,7 @@ static const struct tv_mode tv_modes[] = {
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -819,7 +819,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name       = "1080i@50Hz",
 		.clock		= 148800,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,

@@ -845,7 +845,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name       = "1080i@60Hz",
 		.clock		= 148800,
-		.refresh	= 30000,
+		.refresh	= 60000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,

