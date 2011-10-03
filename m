Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1JCOuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:50:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58491 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab1JCOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:50:33 -0400
From: Jon Mason <mason@myri.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: PCI-E MPS patches for 3.1-rc9
Date: Mon,  3 Oct 2011 09:50:17 -0500
Message-Id: <1317653420-21404-1-git-send-email-mason@myri.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Please include these patches in 3.1-rc9.  The first 2 fix bugs in the
PCI-E MPS "performance" tuning and the third disables MPS tuning by
default.  The patch to disable MPS by default was made at the request
of Bjorn, due to an outstanding regression and the fear that more are
out there.  The MPS tuning can still be enabled via boot arg, which
should correct the issue Greg KH was seeing with some systems being
unable to boot without the MPS tuning enabled.  Hopefully this is
acceptable until such time as all the regressions can be found, solved,
and MPS turning being enabled by default.

Thanks,
Jon

