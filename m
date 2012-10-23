Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab2JWMyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:54:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51365 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006Ab2JWMyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:54:44 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/3 v2] Expose firmware paths via procfs
Date: Tue, 23 Oct 2012 13:52:53 +0100
Message-Id: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, I've rebased these on top of linux-next as you requested.

Dimitris Papastamos (3):
  firmware: Convert firmware path setup from an array to a list
  firmware: Add /proc/firmware_path entry to list the firmware paths
  firmware: Factor out code to add paths to the firmware path list

 drivers/base/firmware_class.c | 137 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 9 deletions(-)

-- 
1.8.0

