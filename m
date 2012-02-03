Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2BCAwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:52:16 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43855
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755520Ab2BCAwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:52:12 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0004] drivers: hv
Date: Thu,  2 Feb 2012 16:56:17 -0800
Message-Id: <1328230577-3263-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set does some cleanup of the KVP component. Also included is a
patch that will remove artificial limitation on the number of VCPUs that
can be assigned to the Linux guest on Hyper-V. This is a resend of a subset
of the patches that was sent earlier. Of the original 6 patch set,
the first two were applied. I am re-sending the remaining four with
the changes Greg wanted.

Regards,

K. Y

