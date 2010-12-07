Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0LGH44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:56:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0LGH4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:56:55 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        Aries Lee <arieslee@jmicron.com>
Subject: [PATCH 0/3] Add support for new JMicron memstick controllers
Date: Tue,  7 Dec 2010 08:56:36 +0100
Message-Id: <1291708599-28026-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix and correct setups for JMicron 38x memory-stick
controllers, and add the support for new controller chips.

The patches have been tested with MS-pro devices on 2.6.37-rc4.


thanks,

Takashi

