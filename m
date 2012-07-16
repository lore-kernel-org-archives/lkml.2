Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2GPFlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:41:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33889 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2GPFlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:41:15 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-14-5003a979d12e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jg1.han@samsung.com, jy0922.shim@samsung.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com
Subject: [PATCH 0/3 v3] USB: host: Add Device tree support for ohci-exynos &
 ehci-s5p
Date: Mon, 16 Jul 2012 11:25:35 +0530
Message-id: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jAd3KlcwBBp/6lS0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBnPpq5mL1jBUvH92UTmBsajzF2MnBwSAiYSx5t+s0HY
	YhIX7q0Hsrk4hAQWMUocWXiBGcJpZ5L43nqGFaSKTUBXountLkYQW0SgVmLK1ansIDazwCtG
	ic7LqiC2sEC4RPvXJSwgNouAqsSs/zfB6nkF3CV2rNnLCrFNQaJ12SH2CYzcCxgZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEe/OZ1A7GlQ0WhxgFOBiVeHgNgF4WYk0sK67MPcQowcGs
	JMLb2QkU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmvs/dVfSCA9sSQ1OzW1ILUIJsvEwSnVwCi4
	87ivIufOrXnbtHNSw31XXrmfJGFwYN0CQ/ETHL4zt06oXbQqyH6z/PsWBuE597Lb117r7WJa
	cvzOHt4q90d8Ovp3W869VFSYKnmt8JWls4Ho5l9FKm8/s2qtSP/LG843mcfszrGc+1NXX5A4
	eq3z+h/RlMtqc9/JPmURNTWcYbxf7aP91M1KLMUZiYZazEXFiQC3KLTr4gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
1) Moved "struct of_device_id exynos_ehci_match[]"
to the next of "struct dev_pm_ops s5p_ehci_pm_ops" in ehci-s5p.c.
2) Rebased on 'usb-next' branch.

Vivek Gautam (3):
  USB: ohci-exynos: Add support for device tree
  USB: ehci-s5p: Add support for device tree
  USB: ehci-s5p: Add vbus setup function to the s5p ehci glue layer

 drivers/usb/host/ehci-s5p.c    |   47 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-exynos.c |   22 ++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

