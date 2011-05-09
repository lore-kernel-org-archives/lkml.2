Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1EISga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:36:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55025 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1EISg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 0/6] x86, MCE, AMD: Hardware MCE injection
Date: Mon,  9 May 2011 20:35:49 +0200
Message-Id: <1304966155-9841-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

this new set version moves the whole interface to debugfs since it
belongs there in the first place. Remaining functionality unchanged.

Changelog:

v2: only small changes from the last submission
(http://lkml.org/lkml/2011/4/15/171) so that we can have valid
MCG_STATUS values and don't choke on severity sanity checking.

v1: Initial submission.


Thanks.
