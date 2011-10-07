Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1JGP1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:27:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50091 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1JGP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:27:50 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] x86 RAS: Reorganize functionality
Date: Fri,  7 Oct 2011 17:27:35 +0200
Message-Id: <1318001259-1720-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

this is a first attempt at reorganizing and concentrating x86 RAS
features under arch/x86/. The idea is to put them close to the MCA code
so that code reuse and extending functionality can be done much more
easily.

This first attempt deals only with AMD RAS features but I expect that we
can put all into one unified menu entry in Kconfig after we've agreed on
the structure.

As always, all comments are welcome.

Thanks.
