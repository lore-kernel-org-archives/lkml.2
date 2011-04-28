Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab1D1Kfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:35:37 -0400
Received: from mail-iy0-f198.google.com ([209.85.210.198]:46151 "EHLO
	mail-iy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1D1Kfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:35:36 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 06:35:36 EDT
MIME-Version: 1.0
Reply-To: dudl@cypress.com, rubini@cvml.unipv.it, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@google.com, micahc@google.com, dso@cypress.com,
        chromium-os-reviews@chromium.org, vb+kernel@google.com,
        msb@chromium.org, olofj@chromium.org
X-Google-Appengine-App-Id: chromiumcodereview
Message-ID: <90e6ba6e8adee93df104a1f7ad35@google.com>
Date: Thu, 28 Apr 2011 10:04:13 +0000
Subject: Update cyapa driver support MT type-A protocol, add cyapa_misc_dev
 interface (issue6905092)
From: dudl@cypress.com
To: rubini@cvml.unipv.it, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@google.com, micahc@google.com, dudl@cypress.com, dso@cypress.com
Cc: chromium-os-reviews@chromium.org, vb+kernel@google.com, msb@chromium.org,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewers: rubini_ipvvis.unipv.it, dmitry.torokhov_gmail.com,  
linux-input_vger.kernel.org, linux-kernel_vger.kernel.org,  
olofj_dontusethisaddress, Micah C, dudl, dso_cypress.com,

Description:
Update cyapa driver support MT type-A protocol, add cyapa_misc_dev interface


Change-Id: I8c70391a581bd1f62803f25fe3a52589b56aeed7
Signed-off-by: Du, Dudley <dudl@cypress.com>

R=rubini@ipvvis.unipv.it,dmitry.torokhov@gmail.com,linux-input@vger.kernel.org,linux-kernel@vger.kernel.org,olofj@google.com,micahc@google.com,dudl@cypress.com,dso@cypress.com
BUG=3220 6902105
TEST=test on kaen board

1. Remove codes that support relative report data, this mode is not  
required for
trackpad any more;
2. Modify cyapa driver support MT type-A protocol working with multitouch X
driver;
3. Add cyapa_misc_dev interface, so applications can get driver, firmware  
and
hardware version of the trackpad device.


Please review this at http://codereview.chromium.org/6905092/

SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.38

Affected files:
   M drivers/input/mouse/cypress_i2c.c
   M include/linux/cyapa.h


