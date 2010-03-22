Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0CVOil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:38:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0CVOij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:38:39 -0400
Date: Mon, 22 Mar 2010 16:34:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Amit Shah <amit.shah@redhat.com>
Subject: [PULL] virtio
Message-ID: <20100322143425.GA19370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Please pull a couple of virtio-console fixes by Amit.

The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:

  Linux 2.6.34-rc2 (2010-03-19 18:17:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for-linus

Amit Shah (2):
      virtio: console: Generate a kobject CHANGE event on adding 'name' attribute
      virtio: console: Check if port is valid in resize_console

 drivers/char/virtio_console.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)
