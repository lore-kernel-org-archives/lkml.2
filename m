Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab1JFOTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab1JFOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:19:07 -0400
Date: Thu, 6 Oct 2011 15:17:13 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        Jonathan Brassow <jbrassow@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [git pull] device-mapper fixes for 3.1
Message-ID: <20111006141713.GB2840@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	stable@kernel.org, Jonathan Brassow <jbrassow@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Doug Ledford <dledford@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  http://people.redhat.com/agk/git/linux-dm for-linus

to get the following device-mapper fixes for inclusion in 3.1:

Jonthan Brassow (1):
      dm: raid fix write_mostly arg validation

Mike Snitzer (2):
      dm: flakey fix corrupt_bio_byte error path
      dm table: avoid crash if integrity profile changes

Milan Broz (1):
      dm crypt: always disable discard_zeroes_data

 drivers/md/dm-crypt.c         |    2 ++
 drivers/md/dm-flakey.c        |    4 +++-
 drivers/md/dm-raid.c          |    2 +-
 drivers/md/dm-table.c         |   32 ++++++++++++++++++++++++++------
 include/linux/device-mapper.h |    5 +++++
 5 files changed, 37 insertions(+), 8 deletions(-)

Thanks,
Alasdair
