Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1GDWmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:42:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55323 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1GDWmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:42:54 -0400
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/2] x86: restore MISC_ENABLE MSR in realmode wakeup
Date: Mon,  4 Jul 2011 15:35:51 -0700
Message-Id: <1309818953-769-1-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.4.1
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a different approach to handle the situation discussed in
https://lkml.org/lkml/2011/7/1/404, this time restoring the entire
MISC_ENABLE MSR.

-Kees

-- 
Kees Cook
Ubuntu Security Team

