Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GPFnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:43:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34910 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GPFnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:43:14 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-07-5003a9f13b7e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: [PATCH 0/2 v3] USB: host: Add Device tree support for dwc3-exynos
Date: Mon, 16 Jul 2012 11:27:37 +0530
Message-id: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t9jAd2PK5kDDHonKFtc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJWfa4ruMxUceHeOrYGxglMXYycHBICJhJPTrexQdhi
	EhfurQeyuTiEBBYxSpxfu4cRJCEk0M4kcWaOE4jNJqAr0fR2F1hcRKBWYsrVqewgNrPAVUaJ
	b69KQWxhAS+JJVfusYLYLAKqEgu6QOZwcPAKeEgcnJ8GsUtBonXZIfYJjNwLGBlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgT78ZnUDsaVDRaHGAU4GJV4eA2A/hViTSwrrsw9xCjBwawk
	wtvZCRTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa+z91V9IID2xJDU7NbUgtQgmy8TBKdXAyHP9
	fuun9VfvRU4VcPCv/lb3VLVET73qfW/Psd7Ec+/Nvoubd6VKXZ/01vbPy715HGKXWJS2THiQ
	M8UoWq1wQ2V/gerFidpeu21vftzrWLozyjlV599CC6llK/+Vz4peF3vuTIy6O6N3VVPO4mst
	Hza4Gq9aJN0w/0dNwORX611tXRjPh+tpKrEUZyQaajEXFScCAEw4DprfAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
1) Rebased on 'usb-next' branch.

Vivek Gautam (2):
  USB: dwc3-exynos: Add support for device tree
  USB: dwc3-exynos: Add vbus setup function to the exynos dwc3 glue
    layer

 drivers/usb/dwc3/dwc3-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

