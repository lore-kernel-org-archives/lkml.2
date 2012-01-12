Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2ALPb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:31:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59957 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab2ALPb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:31:58 -0500
MIME-Version: 1.0
Date: Thu, 12 Jan 2012 23:31:57 +0800
Message-ID: <CAAJw_Zte4JSFeb9zK4gtptBq=H1RoqaSgaV3OpmxuXBY5cZByA@mail.gmail.com>
Subject: bnx2-mips-09-6.2.1.b still missing
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c2c20ef43d00b1439631e603f8dcee9a803cd8b3 mentioned
bnx2-mips-09-6.2.1.b, but it's still missing from the latest git.
Where can I download the bnx2 firmware from?

Thanks,
Jeff



commit c2c20ef43d00b1439631e603f8dcee9a803cd8b3
Author: Michael Chan <mchan@broadcom.com>
Date:   Sun Dec 18 18:15:09 2011 +0000

    bnx2: Update driver to use new mips firmware.

    bnx2-mips-06-6.2.3 and bnx2-mips-09-6.2.1.b

    New firmware fixes iSCSI problems with some LeftHand targets that don't
    set TTT=0xffffffff for Data-In according to spec.  Firmware generates
    exception warnings for this condition and becomes very slow.  This is
    fixed by suppressing these warnings when using default error mask.

    Signed-off-by: Michael Chan <mchan@broadcom.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
