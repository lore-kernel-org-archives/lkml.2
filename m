Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DMRRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:17:39 -0400
Received: from mail.tpi.com ([70.99.223.143]:1361 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2DMRRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:17:38 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: kvalo@qca.qualcomm.com, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next 0/1] ath6k: Normalize use of FW_DIR
Date: Fri, 13 Apr 2012 11:17:26 -0600
Message-Id: <1334337448-26270-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalle - I've been cleaning out old firmware files in the Ubuntu linux-firmware
package and noticed that there are a number of AR6004 firmware files referenced in
the ath6k USB driver that do not exist in the upstream linux-firmware
repository. Are y'all planning to submit them soon ?

rtg

