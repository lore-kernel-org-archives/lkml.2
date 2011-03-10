Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1CJAQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:16:21 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43632 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1CJAQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:16:18 -0500
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] switch DT creation to using of_attach_node
Date: Wed,  9 Mar 2011 16:16:04 -0800
Message-Id: <1299716167-9656-1-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches cause of_attach_node to be used by OF core, both for promtree
and flattree building.

