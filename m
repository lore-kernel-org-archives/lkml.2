Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1EWMdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:33:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1EWMda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:33:30 -0400
Date: Mon, 23 May 2011 14:33:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] APM
Message-ID: <alpine.LNX.2.00.1105231409180.28291@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git for-linus

to receive two patches for legacy APM code I am taking maintainership over 
from Stephen.

Thanks.

Jiri Kosina (1):
      APM: take over maintainership

Paul Parsons (1):
      apm-emulation: apm_mutex breaks ACK; remove it

 MAINTAINERS                  |    5 +++--
 drivers/char/apm-emulation.c |    5 -----
 2 files changed, 3 insertions(+), 7 deletions(-)
