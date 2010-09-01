Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0IAB4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:56:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41645 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0IAB4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:56:30 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7 v3] HID: magicmouse: fixes and support for the Magic Trackpad (v3)
Date: Tue, 31 Aug 2010 21:56:17 -0400
Message-Id: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are a reworking of my previous submission to
incorporate all the comments to date. The only patch of contention, removing
the fuzz factor, has been removed for now.

Thanks,

-- Chase
