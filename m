Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2HFVVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:21:12 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:27983 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2HFVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:21:08 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC ebeam PATCH v3 0/2]
Date: Mon,  6 Aug 2012 23:21:42 +0200
Message-Id: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

New USB input driver for eBeam devices.

Currently, only the Luidia eBeam classic projection model is supported.
Edge model and a NEC interactive video-projector support planned for the
end of the mounth. 

Patch 1 to blacklist the device for hid generic-usb.

Patch 2 is the actual driver.

Changes from previous :
- switch to div64_s64 for portable 64/64-bits divisions
- some cosmetics in device name
- unused include and def removed
- variables name changes for readability

Pending issues :
- sysfs custom files : need to pass 13 parameters for calibration :
  choice is between lots of simply-handled, or few with a big sscanf.
- is div64_s64 safe and available on all plateform ? this is the only
  use of this function i've found in all the kernel tree.

The module run fine with a 3.3.6 and a 3.5.0 kernel, both x86_32 and 64.

Thanks for your help.

