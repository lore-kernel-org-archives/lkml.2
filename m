Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2H2M6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 08:58:30 -0400
Received: from [66.192.166.38] ([66.192.166.38]:38922 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752284Ab2H2M6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 08:58:16 -0400
Date: Wed, 29 Aug 2012 08:40:27 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] [RESEND] add discard support to nbd
Message-ID: <503e0dbb.I+aeTv/2urDODjS3%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ ... resend, as my mailer garbled the last post ... ]

This patchset adds discard request support to nbd. This should be good
for inclusion in next.

The first patch adds a set-flags ioctl, allowing various option flags
to be set on an nbd device. One of the new flags tells the nbd client
to send discard requests to the server.
The second patch adds handling of discard requests to nbd when
NBD_FLAG_SEND_TRIM is set.

Thanks,
Paul
