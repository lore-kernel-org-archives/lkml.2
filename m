Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2DLFgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:36:48 -0400
Received: from ozlabs.org ([203.10.76.45]:57755 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab2DLFgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:36:47 -0400
From: David Gibson <david@gibson.dropbear.id.au>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, qemu-devel@nongnu.org
Subject: [PATCH 0/3] Bugfixes for virtio balloon driver
Date: Thu, 12 Apr 2012 15:36:32 +1000
Message-Id: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains one cleanup and two bug fixes for the virtio
balloon driver.

