Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2H1Vmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 17:42:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58534 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2H1Vml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 17:42:41 -0400
MIME-Version: 1.0
Reply-To: paul.clements@us.sios.com
Date: Tue, 28 Aug 2012 17:42:40 -0400
Message-ID: <CAECXXi6q_NWpughUkwMCs6XeER-W_pHDz4HhhBGbcAmwBKppjA@mail.gmail.com>
Subject: [PATCH 0/2] add discard support to nbd
From: Paul Clements <paul.clements@steeleye.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: andrew morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds discard request support to nbd. This should be good
for inclusion in next.

The first patch adds a set-flags ioctl, allowing various option flags
to be set on an nbd device. One of the new flags tells the nbd client
to send discard requests to the server.
The second patch adds handling of discard requests to nbd when
NBD_FLAG_SEND_TRIM is set.

Thanks,
Paul
