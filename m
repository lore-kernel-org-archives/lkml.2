Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0IHVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:14:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0IHVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZvrVykkdnC7BvQjh5yGXqv23TW0FibMX3VahgudPhrBteqk3YGMlwdQn678GHRXhzV
         Rzq5DjkT2DL7YcJui9BhTf9xcdXw+C/8Xos52o2KW2/OK1uhg/dQDax6oHsFSsr5vdD4
         ayv8v6FzMqU3i5+xlHnGq5PaC0IykHhKveUSQ=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: airlied@linux.ie, ajax@redhat.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 3/8] drivers/gpu/drm: use ARRAY_SIZE macro in drm_edid_modes.h
Date: Wed,  8 Sep 2010 22:14:41 +0100
Message-Id: <1283980481-4933-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(est3_modes) / sizeof(est3_modes[0]) with
ARRAY_SIZE(est3_modes) in drivers/gpu/drm/drm_edid_modes.h

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 drivers/gpu/drm/drm_edid_modes.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid_modes.h b/drivers/gpu/drm/drm_edid_modes.h
index 6eb7592..7601284 100644
--- a/drivers/gpu/drm/drm_edid_modes.h
+++ b/drivers/gpu/drm/drm_edid_modes.h
@@ -377,4 +377,4 @@ static const struct {
 	{ 1920, 1440, 60, 0 },
 	{ 1920, 1440, 75, 0 },
 };
-static const int num_est3_modes = sizeof(est3_modes) / sizeof(est3_modes[0]);
+static const int num_est3_modes = ARRAY_SIZE(est3_modes);
-- 
1.7.2.3

