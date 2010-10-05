Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab0JEKwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37948 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab0JEKwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/8] MCE decoding on F14h
Date: Tue,  5 Oct 2010 12:54:00 +0200
Message-Id: <1286276048-20556-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

continuing the EDAC series from last week
(http://marc.info/?l=linux-kernel&m=128584454524242&w=2), here's an
add-on set which adds MCE decoding for AMD F14h, models 0x0-0xf CPUs on
top of the previous patchqueue. Another change from last week is that we
decided to turn-off building the MCE injection module by default so that
it can be enabled explicitly by distro kernels only (or other curious
individuals who have a lot of time on their hands).

Whole series at git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next

Thanks,
Boris.
