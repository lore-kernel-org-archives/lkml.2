Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1LNQEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:51 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:60345 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab1LNQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:44 -0500
X-AuditID: c1b4fb3d-b7cfeae000005b81-0a-4ee8c91a5374
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: lucas.demarchi@profusion.mobi, borislav.petkov@amd.com,
        tony.luck@intel.com
CC: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH 0/4] edac: i5100 fault injection
Date: Wed, 14 Dec 2011 17:04:26 +0100
Message-ID: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add experimental support for fault injection to the i5100 MC.
Not all information is in the i5100 datasheet some parts where
found using experimentation and the i7300 datasheet which
corresponds a bit to the i5100 in some areas.

Based on previous patch send to this list to improve error detection 
(ref 1) not included in this patchset. I can't find it in any edac
repo, not sure if I should have included it in this patchset or not,
please enlighten me so I know in the future.

[1] [PATCH] edac: i5100 ack error detection register after each read

