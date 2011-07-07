Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1GGPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:25:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1GGPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:25:26 -0400
Subject: [TRIVIAL][PATCH v2 0/2] uninit warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 18:27:03 +0300
Message-ID: <1310052423.3528.40.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

The following patches are already discussed in lkml.

Please apply them to your trivial-next tree.

 kernel/async.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
 kernel/futex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Thanks,
Vitaliy

