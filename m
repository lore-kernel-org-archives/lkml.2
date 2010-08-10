Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0HJXul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:50:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25857 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0HJXue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:50:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6070"; a="50573337"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca, gregkh@suse.de
Subject: [PATCHv2 0/2] platform: Facilitate the creation of pseudo-platform buses
Date: Tue, 10 Aug 2010 16:49:32 -0700
Message-Id: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been split into two patches. The first, trivial patch,
has already been submitted and greg k-h has it queued up for
after the merge window; it is included here only for clarity.

The second patch contains everything interesting :)

[PATCHv2 1/2] platform: Use drv->driver.bus instead of assuming platform_bus_type
[PATCHv2 2/2] platform: Facilitate the creation of pseudo-platform buses
