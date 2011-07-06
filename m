Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1GFQJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:09:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1GFQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:09:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=gECAUblHDYFQznK2tyxnw8/Y+FPpcSLrruWTDwYGhrsnHhIUx4973UGRdx2N3KVlv
	ufEcGVKpCOE5hgJoxZQHA==
Subject: [PATCH 0/2] [RFC] watchdog reboot timeout
To: Wim Van Sebroeck <wim@iguana.be>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Date: Wed, 06 Jul 2011 10:09:31 -0600
Message-ID: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for comments on these patches.  I'm not really happy with
them because they add basically identical code in each driver.  I also
don't like the fact that the parameter is not generic, so I have to know
which driver will be used on my machine.

Bjorn


Bjorn Helgaas (2):
      watchdog: iTCO_wdt: optionally leave watchdog enabled during restart
      watchdog: nv_tco: optionally leave watchdog enabled during restart


 drivers/watchdog/iTCO_wdt.c |   13 +++++++++++++
 drivers/watchdog/nv_tco.c   |   13 +++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)
