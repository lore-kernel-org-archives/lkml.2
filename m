Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1ASAM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:12:29 -0500
Received: from www17.your-server.de ([213.133.104.17]:45880 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1ASAM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:12:28 -0500
Subject: 2.6.37-08009-ge6f597a "feels" slow - rhythmbox skips audio
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 01:09:50 +0100
Message-ID: <1295395790.3327.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

kernel version 2.6.37-08009-ge6f597a "feels" slow and background audio
skips/stalls when performing some cpu (and/or io?) intensive tasks like
a kernel compile or grepping for a string in the kernel source or
upgrading the system via yum upgrade.

I didn't see this behaviour with 2.6.37 (and previous versions) on my UP
system.

Any idea what's happening here?

with kind regards
thomas

