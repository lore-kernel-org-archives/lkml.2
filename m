Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab2JCRrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:47:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48978 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174Ab2JCRro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:47:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 3 Oct 2012 19:47:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.6
Message-ID: <20121003194731.226dd535@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-updates" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-updates

to receive the following IEEE 1394 (FireWire) subsystem changes:
  - Feed GUIDs of FireWire nodes to the random pool,
  - more complete quirk handling of a TI S400B phy,
  - avoid holding a core lock while calling into highlevel drivers.
Thanks.

Clemens Ladisch (1):
      firewire: core: feed /dev/random with devices' GUIDs

Peter Hurley (1):
      firewire: remove global lock around address handlers, convert to RCU

Stefan Richter (1):
      firewire: addendum to address handler RCU conversion

Stephan Gatzka (1):
      firewire: ohci: get IR bit from TSB41BA3D phy

 drivers/firewire/core-device.c      |  3 +++
 drivers/firewire/core-transaction.c | 33 +++++++++++++++++++--------------
 drivers/firewire/ohci.c             | 28 +++++++++++++++++++++++++++-
 include/linux/firewire.h            | 12 ++++++++++--
 4 files changed, 59 insertions(+), 17 deletions(-)
-- 
Stefan Richter
-=====-===-- =-=- ---==
http://arcgraph.de/sr/
