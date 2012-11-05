Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2KENbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:31:33 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54931 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab2KENbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:31:31 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] drm/ttm: Get rid of a number of atomic read-modify-write ops
Date: Mon,  5 Nov 2012 14:31:14 +0100
Message-Id: <1352122278-12896-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch series for next that removes a substantial number of read-modify-write
operations from TTM command submission, in particular if TTM objects are used
to export objects to user-space. The only per-object atomic r-m-w operations
left during a typical execbuf call should be refcount up and down.

In-Reply-To: 

