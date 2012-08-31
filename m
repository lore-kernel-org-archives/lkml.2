Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2HaPsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:48:04 -0400
Received: from [66.192.166.38] ([66.192.166.38]:55471 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754331Ab2HaPsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:48:03 -0400
Date: Fri, 31 Aug 2012 11:48:02 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] nbd: add discard support
Message-ID: <5040dcb2.Tu+/R9CHz3zBC0Mi%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds discard request support to nbd. This should be good
for inclusion in next.

The first patch adds a set-flags ioctl, allowing various option flags
to be set on an nbd device. One of the new flags (NBD_FLAG_SEND_TRIM)
tells the nbd client to send discard requests to the server.

The second patch adds handling of discard requests to nbd when
NBD_FLAG_SEND_TRIM is set.

Thanks,
Paul
