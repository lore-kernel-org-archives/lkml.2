Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1BVCl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:41:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1BVClY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:24 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il
Subject: [PATCH 0/7] Second batch of Tegra clock updates for 2.6.39
Date: Mon, 21 Feb 2011 18:39:45 -0800
Message-Id: <1298342392-21236-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains two small patches out of the previous
series that needed fixes, as well as some new ones to disable
unused clocks during boot and related bug fixes.

Patch 4 converts the Harmony and Trimslice boards to use the new
init_early machine handler.  Any boards that go in after this
patch will need to be updated to match, and this patch will need
to be updated if any boards go in before this patch.

Tested-bys on Harmony and Trimslice would be appreciated.

