Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2IEUcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:32:01 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52938
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754323Ab2IEUcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:32:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V5 0/6] Tools: hv: kvp 
Date: Wed,  5 Sep 2012 13:49:48 -0700
Message-Id: <1346878188-30822-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resubmission of the subset of the patches that were not
accepted in an earlier submission. The only change in this patchset
(relative to the previous version - V4) is that the example script
for retrieving DHCP state prints the string "Disabled" to indicate
that DHCP is not enabled. This was based on Greg's feedback.

K. Y. Srinivasan (6):
  Tools: hv: Add an example script to retrieve dhcp state
  Tools: hv: Gather DHCP information
  Tools: hv: Add an example script to configure an interface
  Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
  Tools: hv: Rename the function kvp_get_ip_address()
  Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO

 include/linux/hyperv.h       |    2 +
 tools/hv/hv_get_dhcp_info.sh |   28 ++
 tools/hv/hv_kvp_daemon.c     |  573 +++++++++++++++++++++++++++++++++++++++++-
 tools/hv/hv_set_ifconfig.sh  |   68 +++++
 4 files changed, 665 insertions(+), 6 deletions(-)
 create mode 100755 tools/hv/hv_get_dhcp_info.sh
 create mode 100755 tools/hv/hv_set_ifconfig.sh

-- 
1.7.4.1

