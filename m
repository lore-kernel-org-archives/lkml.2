Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1KDCzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:55:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab1KDCzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:55:08 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Override arbitrary ACPI tables via initrd
Date: Fri,  4 Nov 2011 03:54:49 +0100
Message-Id: <1320375291-5622-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a resend with a tiny fix which came up in the last thread
incorporated.

The first patch needs to go into ACPICA sources as well.

Both patches are in the latest SUSE factory kernel for a while and will
show up in openSUSE 12.1.

It would be great to see these queued up for 3.2.

Thanks,

   Thomas

