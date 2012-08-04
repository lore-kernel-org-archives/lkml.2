Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2HDHPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:15:25 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:57501 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HDHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:15:20 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 0/5] staging/csr: cleanup patches
Date: Sat,  4 Aug 2012 13:00:08 +0545
Message-Id: <1344064508-11975-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These patches does

* coding style fixes
* little cleanups like unneeded initialisations and 
  comparing a bool against 1 in if

each and every patch is compile tested on top of the previous one

Thanks,

----------------------------

Actually i have a question about the dbg macros, unifi_warning,
unifi_error, and unifi_trace,

I think these can be implemented using dev_warn, dev_dbg, functions,
i mean we can remove these unifi_warning and unifi_error and unifi_trace
and use the dev_warn and dev_dbg.

Please correct me if i am wrong

Devendra Naga (5):
  staging/csr: clean coding style in uf_start_thread
  staging/csr: fix coding style problems in uf_stop_thread
  staging/csr: fix coding style problems in uf_wait_for_thread_to_stop
  staging/csr: remove the initialisation of interfaceTag and its
    comment in handle_bh_error
  staging/csr: fix coding style problems in handle_bh_error

 drivers/staging/csr/bh.c |  173 ++++++++++++++++++++++++----------------------
 1 file changed, 90 insertions(+), 83 deletions(-)

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
-- 
1.7.9.5

