Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab2JKBbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:31:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40984 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342Ab2JKBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:31:28 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-58-50762167cf58
Message-id: <50762167.8060806@samsung.com>
Date: Thu, 11 Oct 2012 10:31:19 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] extcon fixes for Linux 3.6
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd10xbIAg/VdahaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjzt2zjAXnBSsObe1hbWDs4+ti5OSQEDCRmHLsDhuELSZx4d56
	IJuLQ0hgEaPEl53djBBOF5PEi2mPmUCqeAW0JA6/W88CYrMIqEq8eXuBHcRmA4rvf3EDqJuD
	Q1QgQuJXPwdEuaDEj8n3wMpFBDQkXh69xQIyk1lgOaPE0avPwXqFBfQkeqd/YQSxmQV0JPa3
	TmODsOUlNq95yzyBkW8WklmzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	SD2T2sG4ssHiEKMAB6MSD+/ElaUBQqyJZcWVuYcYJTiYlUR4Ex8ChXhTEiurUovy44tKc1KL
	DzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhgjpconxpotPcgcaf/U0+rE1uU/exT1
	797RP+LoFf7j7msDdYufKw8oZeqH9DzXCmibfGjt36wN9vefvcpuEHur+bQlfzP3n+hJhzqL
	KnrlRPU+dheEsoac5lO+dKbALGb7I+mFF7vslbLPu5h/90myrA+/PDds3UfGbaZX9Z6x9y1g
	vSX36oESS3FGoqEWc1FxIgDGH3yxJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please pull extcon fixes for Linux 3.6 from:

    git://git.infradead.org/users/kmpark/linux-samsung extcon-for-next

I've been creating "extcon-for-next" tree at git.infradead.org
and rebasing the branch base on your
driver-core.git(branch:driver-core-next).

This tree contains various small bugfixes and enhancements, fix typos.
And extcon-max77693 initialize MUIC register during probe()
to unmask internal interrupt of max77693 MUIC device.

Thanks,
Chanwoo Choi

--------------------

The following changes since commit e0f21e6d52cc245e7d4f7e02ca4b7b6571660ec2:
  Axel Lin (1):
        memory: tegra{20,30}-mc: Fix reading incorrect register in
mc_readl()

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung extcon-for-next

Axel Lin (4):
      extcon: adc-jack: Fix checking return value of request_any_context_irq
      extcon: adc-jack: Add missing MODULE_LICENSE
      extcon: Fix kerneldoc for extcon_set_cable_state and
extcon_set_cable_state_
      extcon: max77693: Use max77693_update_reg for rmw operations

Chanwoo Choi (1):
      extcon: MAX77693: Add platform data for MUIC device to initialize
registers

Devendra Naga (1):
      extcon-max8997: remove usage of ret in
max8997_muic_handle_charger_type_detach

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Sachin Kamat (2):
      extcon: Remove duplicate inclusion of extcon.h header file
      extcon: Fix return value in extcon_register_interest()

anish kumar (3):
      extcon: standard cable names definition and declaration changed
      extcon: optimising the check_mutually_exclusive function
      extcon: checkpatch warning removal

 drivers/extcon/extcon-adc-jack.c |   10 ++++++--
 drivers/extcon/extcon-class.c    |   34 ++++++++++++++--------------
 drivers/extcon/extcon-gpio.c     |    1 -
 drivers/extcon/extcon-max77693.c |   45
+++++++++++++++++++++++++++----------
 drivers/extcon/extcon-max8997.c  |    6 +---
 include/linux/extcon.h           |    2 +-
 include/linux/mfd/max77693.h     |   13 +++++++++++
 7 files changed, 73 insertions(+), 38 deletions(-)
