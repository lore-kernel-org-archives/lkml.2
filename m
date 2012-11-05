Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2KENz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:55:59 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:54244 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2KENz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:55:56 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] drm/ttm: Get rid of a number of atomic read-modify-write ops v2
Date: Mon,  5 Nov 2012 14:55:40 +0100
Message-Id: <1352123744-13269-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch series for next that removes a substantial number of read-modify-write
operations from TTM command submission, in particular if TTM objects are used
to export objects to user-space. The only per-object atomic r-m-w operations
left during a typical execbuf call should be refcount up and down.

v2: Formatting fixes.

In-Reply-To: 

>From Thomas Hellstrom <thellstrom@vmware.com> # This line is ignored.
From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: 
In-Reply-To: 

