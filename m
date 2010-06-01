Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0FAN31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:29:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45647 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab0FAN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/6] AMD64 EDAC fixes and updates
Date: Tue,  1 Jun 2010 15:29:25 +0200
Message-Id: <1275398971-12439-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here are a couple of EDAC updates which had piled up for a while. I
waited for the merge window to close before sending them out for review
so here we go. The respective commit messages should be quite verbose
wrt to what is being changed so no explanations here except...

Ingo, 0004-x86-mce-Notify-about-corrected-events-too.patch is
x86-specific and leverages the MCE polling mechanism for conveying
correctable ECC info to EDAC and thus removes one of the two mechanisms
which do roughly one and the same thing. It also cuts off ca 120 lines
of EDAC fat which is cool. Anyways, this one and the next have to go in
lockstep before going upstream so let me know how you want to handle
this.

Thanks.
