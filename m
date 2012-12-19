Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2LSN2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:28:34 -0500
Received: from mx2.parallels.com ([64.131.90.16]:37132 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2LSN21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:28:27 -0500
From: Alexander Kartashov <alekskartashov@parallels.com>
To: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <gorcunov@openvz.org>, <xemul@parallels.com>
Subject: Enable the syscall kcmp in ARM Linux port
Date: Wed, 19 Dec 2012 17:27:54 +0400
Message-ID: <1355923677-18249-1-git-send-email-alekskartashov@parallels.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear colleagues,

I'm developing an ARM port of the CRIU suite
so I need the syscall kcmp that is currently
available only in the x86 port of the kernel.

This patchset enables the syscall kcmp
in the ARM port of the Linux kernel.

--
Sincerely yours,
Alexander Kartashov

