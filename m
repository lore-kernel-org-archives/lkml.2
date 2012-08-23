Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab2HWALs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:11:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2HWALp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:11:45 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-9c-5035753f63bc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: pmeerw@pmeerw.net, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, trivial@kernelg.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/4] extcon: fix typos
Date: Thu, 23 Aug 2012 09:11:39 +0900
Message-id: <1345680699-5838-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAV2HUtMAg/Z3zBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjftcSloLHLBUrD35lbmDcx9zFyMkhIWAicev2S0YIW0ziwr31
	bF2MXBxCAosYJRp/vWGFcJYySby+08YGUsUmoCWx/8UNMFtEQE7iye0/zCBFzALLGSVab70H
	SwgLqElc2jiHFcRmEVCV+H9jAxOIzSvgIjFj8VuodQoSrcsOsU9g5F7AyLCKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTI9iLz6R3MK5qsDjEKMDBqMTDmxFrGiDEmlhWXJl7iFGCg1lJhLer
	CCjEm5JYWZValB9fVJqTWnyIUZqDRUmcl7/PMEBIID2xJDU7NbUgtQgmy8TBKdXAyKNt80XM
	I/tXTuvkU1llqSf6tP99EuF0m6s0OazUSXjfbt+vZ3N8BL0Yu7/Mm8ST7RWyJKfk8dF337NL
	+Z4arrmkant/QbaMPdOlDb0fz/7k7XmzpeONkVujQPfaswv8z1zdyMXiaHJv/6GNqYXfcg9f
	aN2p7P/Weclpvb51Cqrrr52yMvq4TomlOCPRUIu5qDgRAN0cLvbeAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix typos of extcon by Peter Meerwald.

Peter Meerwald (4):
  extcon: fix typos in sys-class-extcon
  extcon: fix typos in max77693 driver
  extcon: fix typos in extcon-arizona
  extcon: fixing typos

 Documentation/ABI/testing/sysfs-class-extcon |   22 +++++++++++-----------
 drivers/extcon/extcon-arizona.c              |    4 ++--
 drivers/extcon/extcon-class.c                |    8 ++++----
 drivers/extcon/extcon-max77693.c             |    6 +++---
 include/linux/extcon.h                       |   18 +++++++++---------
 5 files changed, 29 insertions(+), 29 deletions(-)

