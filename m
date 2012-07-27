Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2G0WnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:43:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47628 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2G0WnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:43:08 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [0/4] pm_idle, default_idle cleanup
Date: Fri, 27 Jul 2012 18:42:51 -0400
Message-Id: <1343428975-3897-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.12.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 1st three patches in this series are specific to x86.
With an ack from the x86 crew (the main patch still has Ingo's ack
from 16 months ago) I think they could be 3.6-rc1 cleanup candidates.

The 4th patch is enabled by the first 3 -- removing pm_idle() from pm.h
touches 10 architectures.  That one will need a bunch of acks and
post rc1 linux-next build testing to make sure it doesn't break 3.7.

thanks,
Len Brown, Intel Open Source Technology Center

