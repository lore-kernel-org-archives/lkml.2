Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2DWWaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:30:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36569 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2DWWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:30:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Get rid of PowerPC users of NR_IRQS
Date: Mon, 23 Apr 2012 16:30:00 -0600
Message-Id: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Here's the 2nd version of the NR_IRQS cleanup patches for PowerPC.  I've
addressed your comments and compile tested them, but I've not tried to
boot.  If they check out for you then they should probably go into v3.4.

g.

