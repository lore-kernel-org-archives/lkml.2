Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1D1H1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:27:20 -0400
Received: from mail-iy0-f198.google.com ([209.85.210.198]:46724 "EHLO
	mail-iy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1D1H1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:27:19 -0400
X-Greylist: delayed 1588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 03:27:19 EDT
MIME-Version: 1.0
Reply-To: dudl@cypress.com, ccross@android.com, konkers@android.com,
        olof@lixom.net, linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        micahc@google.com, dso@cypress.com, chromium-os-reviews@chromium.org,
        vb+kernel@google.com, msb@chromium.org, olofj@chromium.org
X-Google-Appengine-App-Id: chromiumcodereview
Message-ID: <90e6ba3fd225155e1504a1f51e79@google.com>
Date: Thu, 28 Apr 2011 07:00:50 +0000
Subject: update cyapa_i2c_platfrom_data, remove relative mode supporting. (issue6902105)
From: dudl@cypress.com
To: ccross@android.com, konkers@android.com, olof@lixom.net,
        linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        micahc@google.com, dudl@cypress.com, dso@cypress.com
Cc: chromium-os-reviews@chromium.org, vb+kernel@google.com, msb@chromium.org,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewers: ccross_android.com, konkers_android.com, olof_lixom.net,  
linux_arm.linux.org.uk, linux-tegra_vger.kernel.org,  
linux-arm-kernel_lists.infradead.org, linux-kernel_vger.kernel.org, Micah  
C, dudl, dso_cypress.com,

Description:
update cyapa_i2c_platfrom_data, remove relative mode supporting.

Change-Id: Ic9fb8f11c8a4343ff7746f6f885e26d22e773830
Signed-off-by: Du, Dudley <dudl@cypress.com>

R=ccross@android.com,konkers@android.com,olof@lixom.net,linux@arm.linux.org.uk,linux-tegra@vger.kernel.org,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,micahc@google.com,dudl@cypress.com,dso@cypress.com
BUG=
TEST=test on kaen board

1. becasuse relative mode is removed from cyapa driver, so setting for using
relative or absolute mode are also removed in platform data.


Please review this at http://codereview.chromium.org/6902105/

SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.38

Affected files:
   M arch/arm/mach-tegra/board-seaboard.c


Index: arch/arm/mach-tegra/board-seaboard.c
diff --git a/arch/arm/mach-tegra/board-seaboard.c  
b/arch/arm/mach-tegra/board-seaboard.c
index  
090ae201153aa6fdb87f7095e9b43ec65aa183d9..b52eec18d314ec75bb4a551baf3b19fce0ad274a  
100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -206,8 +206,6 @@ static struct cyapa_platform_data  
cyapa_i2c_platform_data = {
  	.flag				= 0,
  	.gen				= CYAPA_GEN2,
  	.power_state			= CYAPA_PWR_ACTIVE,
-	.use_absolute_mode		= false,
-	.use_polling_mode		= false,
  	.polling_interval_time_active	= CYAPA_ACTIVE_POLLING_INTVAL_TIME,
  	.polling_interval_time_lowpower	= CYAPA_LOWPOWER_POLLING_INTVAL_TIME,
  	.active_touch_timeout		= CYAPA_ACTIVE_TOUCH_TIMEOUT,


