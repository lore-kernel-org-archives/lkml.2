Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab1FGSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1FGSQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:16:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: [PATCH v2 0/3] Oops capture via EFI 
Date: Tue,  7 Jun 2011 14:15:59 -0400
Message-Id: <1307470562-15633-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 just has Tony's review comments addressed. I've re-added the hunk I
accidentally deleted in 2/3, and most of the efivars code is now under
CONFIG_PSTORE in efivars.

