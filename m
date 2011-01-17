Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1AQIfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:35:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:50257 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1AQIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:35:07 -0500
From: "Stanley.Miao" <stanley.miao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] Support BE8 kernel modules relocation
Date: Mon, 17 Jan 2011 16:42:06 +0800
Message-Id: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 17 Jan 2011 08:34:58.0559 (UTC) FILETIME=[6CCAB0F0:01CBB621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch is to solve the BE8 kernel modules relocation problems.

The second patch is to support BE8 kernel on a little-endian machine.

The third patch is to add some debug macros to help the developer to location the boot problems.

In order to test the first patch, I am sure some people will need the other two patches, so I send them together.

Stanley.
