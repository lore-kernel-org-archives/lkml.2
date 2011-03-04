Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab1CDKpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:45:30 -0500
Received: from mail-qw0-f78.google.com ([209.85.216.78]:38171 "EHLO
	mail-qw0-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1CDKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:45:29 -0500
X-Greylist: delayed 10570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 05:45:29 EST
MIME-Version: 1.0
Reply-To: dudl@cypress.com, rubini@cvml.unipv.it, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@google.com, micahc@google.com, chromium-os-reviews@chromium.org,
        vb+kernel@google.com, msb@chromium.org, olofj@chromium.org
X-Google-Appengine-App-Id: chromiumcodereview
Message-ID: <bcaec52c66a51e1eda049da36252@google.com>
Date: Fri, 04 Mar 2011 07:49:18 +0000
Subject: Add new i2c-based input mouse driver into input subsystem for Cypress
 trackpad devices. (issue6626009)
From: dudl@cypress.com
To: rubini@cvml.unipv.it, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@google.com, micahc@google.com, dudl@cypress.com
Cc: chromium-os-reviews@chromium.org, vb+kernel@google.com, msb@chromium.org,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewers: rubini_ipvvis.unipv.it, dmitry.torokhov_gmail.com,  
linux-input_vger.kernel.org, linux-kernel_vger.kernel.org, olofj_g, Micah  
C, dudl,

Description:
Add new i2c-based input mouse driver into input subsystem for Cypress  
trackpad
devices.

Through this new added driver,
Cypress i2c-based trackpad devices will be supported in Linux based system
which are developed based on Cypress self-designed PSOC chipset.
This driver reads trackpad data using i2c interfaces and report cursor
moving data and gesture combined keys to input subsystem.


Change-Id: I108ad1505f3d34ab24658921a772e937940a1b88
Signed-off-by: Du, Dudley <dudl@cypress.com>

BUG=None
TEST=Work fine on ARM tegra2 saeboard and kaen platfrom

Please review this at http://codereview.chromium.org/6626009/

SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.37

Affected files:
   M drivers/input/mouse/Kconfig
   M drivers/input/mouse/Makefile
   A drivers/input/mouse/cypress_i2c.c
   A include/linux/cyapa.h


