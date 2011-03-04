Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab1CDTIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:08:55 -0500
Received: from mail-vw0-f78.google.com ([209.85.212.78]:58177 "EHLO
	mail-vw0-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1CDTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:08:54 -0500
X-Greylist: delayed 21944 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 14:08:53 EST
MIME-Version: 1.0
Reply-To: dudl@cypress.com, olofj@chromium.org, micahc@google.com,
        rklein@nvidia.com, amartin@nvidia.com, bleung@chromium.org,
        linux-kernel@vger.kernel.org, chromium-os-reviews@chromium.org,
        vb+kernel@google.com, msb@chromium.org, sleffler+cc@chromium.org
X-Google-Appengine-App-Id: chromiumcodereview
Message-ID: <20cf300fb35d8ff815049da73f34@google.com>
Date: Fri, 04 Mar 2011 12:25:58 +0000
Subject: CHROMIUM: config: enable Cypress CYAPA trackpad (issue6628011)
From: dudl@cypress.com
To: olofj@chromium.org, micahc@google.com, rklein@nvidia.com,
        amartin@nvidia.com, dudl@cypress.com, bleung@chromium.org,
        linux-kernel@vger.kernel.org
Cc: chromium-os-reviews@chromium.org, vb+kernel@google.com, msb@chromium.org,
        sleffler+cc@chromium.org, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewers: Olof Johansson, Micah C, Rhyland Klein, amartin, dudl, Benson  
Leung, linux-kernel_vger.kernel.org,

Description:
CHROMIUM: config: enable Cypress CYAPA trackpad

Change-Id: I81b32ee63e740cfa6f6c835da83e423ac08664c0
Signed-off-by: Du, Dudley <dudl@cypress.com>

BUG=None
TEST=Test based on ARM tegra2 seaboard and Kaen platfrom.

Please review this at http://codereview.chromium.org/6628011/

SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.37

Affected files:
   M chromeos/config/armel/config.flavour.chromeos-tegra2


Index: chromeos/config/armel/config.flavour.chromeos-tegra2
diff --git a/chromeos/config/armel/config.flavour.chromeos-tegra2  
b/chromeos/config/armel/config.flavour.chromeos-tegra2
index  
9adc8434ad4a6d64c6c735c9d6301bd6b58bde65..90426ec98dc198881081bf070f65d56c833871dd  
100644
--- a/chromeos/config/armel/config.flavour.chromeos-tegra2
+++ b/chromeos/config/armel/config.flavour.chromeos-tegra2
@@ -71,6 +71,7 @@ CONFIG_HAVE_PWM=y
  CONFIG_HOTPLUG_CPU=y
  CONFIG_HW_PERF_EVENTS=y
  CONFIG_I2C_TEGRA=y
+CONFIG_MOUSE_CYPRESS_I2C=y
  # CONFIG_INPUT_PWM_BEEPER is not set
  CONFIG_KEYBOARD_ATKBD=y
  CONFIG_KEYBOARD_TEGRA=y


