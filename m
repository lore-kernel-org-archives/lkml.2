Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1CXOWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab1CXOWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:22:52 -0400
Date: Thu, 24 Mar 2011 14:22:36 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Babu Moger <babu.moger@lsi.com>, Hannes Reinecke <hare@suse.de>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mustafa Mesanovic <mume@linux.vnet.ibm.com>,
        Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.39
Message-ID: <20110324142235.GO27449@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Josef Bacik <josef@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Babu Moger <babu.moger@lsi.com>, Hannes Reinecke <hare@suse.de>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mustafa Mesanovic <mume@linux.vnet.ibm.com>,
	Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes and enhancements for inclusion in
2.6.39.

Josef Bacik (1):
      dm: add flakey target

Mike Snitzer (2):
      dm mpath: fail message ioctl if specified path is not valid
      dm mpath: allow table load with no priority groups

Milan Broz (4):
      dm: fix opening log and cow devices for read only tables
      dm crypt: wipe keys string immediately after key is set
      dm ioctl: prepare for crypt key wiping
      dm ioctl: add flag to wipe buffers for secure data

Mustafa Mesanovic (1):
      dm stripe: implement merge method

 Documentation/device-mapper/dm-flakey.txt |   17 +++
 drivers/md/Kconfig                        |    6 +
 drivers/md/Makefile                       |    1 +
 drivers/md/dm-crypt.c                     |   19 ++-
 drivers/md/dm-flakey.c                    |  212 +++++++++++++++++++++++++++++
 drivers/md/dm-ioctl.c                     |   46 ++++--
 drivers/md/dm-log.c                       |    2 +-
 drivers/md/dm-mpath.c                     |   17 ++-
 drivers/md/dm-snap.c                      |    2 +-
 drivers/md/dm-stripe.c                    |   23 +++-
 include/linux/dm-ioctl.h                  |   12 ++-
 11 files changed, 326 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-flakey.txt
 create mode 100644 drivers/md/dm-flakey.c

Thanks,
Alasdair.
