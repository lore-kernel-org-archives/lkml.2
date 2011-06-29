Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1F2OVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:21:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:49486
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753845Ab1F2OVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:21:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/40] Staging: hv: Driver cleanup
Date: Wed, 29 Jun 2011 07:38:21 -0700
Message-Id: <1309358301-8488-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers:

	1) Cleanup the reference counting mess for both stor and net devices.

	2) Handle all block devices using the storvsc driver.
	  
	3) Accomodate some host side scsi emulation bugs.

	4) In case of scsi errors off-line the device.


Regads,

K. Y 


