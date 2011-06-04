Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1FDKhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:37:21 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:8300 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1FDKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:37:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALkJ6k2Q/khR/2dsb2JhbABSpkZ3rFCdR4YhBJB5jzw
X-IronPort-AV: E=Sophos;i="4.65,319,1304294400"; 
   d="scan'208";a="92239038"
From: Stijn Devriendt <sdevrien@cisco.com>
To: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com
Subject: [PATCH v2] Add support for the Philips SA56004 temperature sensor
Date: Sat,  4 Jun 2011 12:37:10 +0200
Message-Id: <1307183831-19627-1-git-send-email-sdevrien@cisco.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Added documentation
- Replaced error trace with BUG_ON
- Renamed local_ext_offset to reg_local_ext
- Fixed style issues
