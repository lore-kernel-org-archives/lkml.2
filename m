Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab0HEMeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:34:14 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:44375 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933302Ab0HEMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:34:09 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <gregkh@suse.de>
Cc: <akpm@linux-foundation.org>, <STEricsson_nomadik_linux@list.st.com>,
        <etienne.carriere@stericsson.com>, <vincent.guittot@stericsson.com>
Subject: Patch series For U6/U6715 platform support
Date: Thu, 5 Aug 2010 14:28:50 +0200
Message-ID: <1281011335-25761-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch series is almost the final one, if no more comment.
I only change the changelog of [PATCH 5/5] to my previous submission.
The 3 first patches are U6715 ARM platform concern only, may be merged
in Russell arm tree.
The 2 latest patches concern the 8250 serial driver, Greg must update
the changelog of patch "U6715 16550A serial driver support" in linux-next
tree and merge the platform U6715 serial driver patch synchronized with
Russell ack (see Andrew previous suggestion). 

Thanks
Philippe
