Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2LLMic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:38:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:47162 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2LLMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:38:31 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        masami.hiramatsu.pt@hitachi.com, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv9 0/2] virtio_console: Add rproc_serial driver
Date: Wed, 12 Dec 2012 13:38:19 +0100
Message-Id: <1355315901-3085-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set introduces a new virtio type "rproc_serial" for communicating
with remote processors over shared memory. The driver depends on the
the remoteproc framework. As preparation for introducing "rproc_serial"
I've done a refactoring of the transmit buffer handling.

NOTE: These two patches are identical to first two patches of the V8 patch-set,
but are rebased to virtio-next.

Regards,
Sjur

Sjur Brændeland (2):
  virtio_console: Merge struct buffer_token into struct port_buffer
  virtio_console: Add support for remoteproc serial

 drivers/char/virtio_console.c   |  317 +++++++++++++++++++++++++++------------
 include/uapi/linux/virtio_ids.h |    1 +
 2 files changed, 221 insertions(+), 97 deletions(-)

-- 
1.7.5.4

