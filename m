Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0FVNCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:02:46 -0400
Received: from i1.inoi.fi ([194.100.97.46]:40210 "EHLO mail.inoi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0FVNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:02:44 -0400
From: Petri Lehtinen <petri.lehtinen@inoi.fi>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, netdev@vger.kernel.org
Subject: [stable] Please apply ucc_geth driver fixes to 2.6.32-stable
Date: Tue, 22 Jun 2010 16:02:29 +0300
Message-Id: <1277211752-14265-1-git-send-email-petri.lehtinen@inoi.fi>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I already sent these patches a few weeks ago and got no reply. I also
sent them to some of the recipients a few minutes ago and failed to
use git-send-email properly. So sorry for the noise.)

Please include the following three patches to 2.6.32-stable. They fix
serious flaws in the ucc_geth ethernet driver, making it unusable (at
least on my system).

They have been included in 2.6.33 and apply cleanly on top of
2.6.32-stable.

