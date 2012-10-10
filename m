Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2JJK66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:58:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33695 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab2JJK65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:58:57 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] Expose firmware paths via procfs
Date: Wed, 10 Oct 2012 11:56:23 +0100
Message-Id: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.12.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, sorry missed the relevant CCs before.  This patch set
adds support for exposing the firmware paths via procfs.  I've added
an entry named /proc/fw_path which is a whitespace separated list
of firmware paths.

Once I have some time I hope to also send out a patch that allows
the user to dynamically configure these paths.

Dimitris Papastamos (2):
  firmware: Convert firmware path setup from an array to a list
  firmware: Add /proc/fw_path entry to list the firmware paths

 drivers/base/firmware_class.c | 127 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 119 insertions(+), 8 deletions(-)

-- 
1.7.12.2

