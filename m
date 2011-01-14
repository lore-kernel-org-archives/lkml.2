Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1ANFqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:46:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34912 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1ANFqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:46:05 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: tidspbridge for 2.6.38
Date: Thu, 13 Jan 2011 23:34:51 -0600
Message-Id: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set of important changes for 2.6.38, to fix a critical bug (1) and a
compile break (2).

Guzman Lugo, Fernando (1):
  staging: tidspbridge: configure full L1 MMU range

Omar Ramirez Luna (1):
  staging: tidspbridge: replace mbox callback with notifier_call

 drivers/staging/tidspbridge/core/tiomap3430.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

