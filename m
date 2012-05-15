Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2EOIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:25:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52080 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab2EOIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:25:54 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-31-4fb2130b69d1
From: Namhyung Kim <namhyung.kim@lge.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Cc: Hyeoncheol Lee <cheol.lee@lge.com>
Subject: [QUESTION] Kprobes as a module?
Date: Tue, 15 May 2012 17:24:11 +0900
Message-ID: <87zk99zwb8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Probably a dumb question :).
What prevents the kprobes from being built as a module? We want to use
the kprobes on our systems, but some guys worried about potential
security problems. So it'd be great if we can enable/load kprobes as
needed and then disable/unload after using it. Is it a possible senario?

Thanks,
Namhyung
