Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2ADSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:15:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2ADSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:15:29 -0500
Date: Wed, 4 Jan 2012 10:15:25 -0800
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl
Subject: sysrq-o broken since 2.6.38
Message-ID: <20120104181525.GA21816@linuxace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 1eb208ae [PM: Make CONFIG_PM depend on (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME)],
sysrq-o option no longer works unless PM_SLEEP or PM_RUNTIME is enabled.  I doubt
this was an intended consequence of this change.  Rafael?

Thanks,
Phil
