Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2G3TWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:22:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53021 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2G3TWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:22:45 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 0/6] menuconfig: jump to search results
Date: Mon, 30 Jul 2012 15:22:04 -0400
Message-Id: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds "jump to" keys (similar to the cscope interface) to the
search results of "make menuconfig" so that we can go directly to the menu
entry for a config option after searching for it.

Patches 1-4 implement the basic functionnality.
Patches 5-6 are an optionnal improvement.

Enjoy,
-Benjamin

