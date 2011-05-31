Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1EaUWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:22:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387Ab1EaUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:22:00 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/4] Some x86, asm cleanups
Date: Tue, 31 May 2011 22:21:50 +0200
Message-Id: <1306873314-32523-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.3.401.gfb674
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a couple of asm cleanups. I hope I don't break some esoteric
gas version with them. They survived booting into kvm and on a couple of
different machines so I might get lucky.

Suggestions welcome, as always.

Thanks.
