Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0KPRSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:18:25 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:43930 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753243Ab0KPRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:18:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=M7ip2OvLixT2KTXsijBKI8qWvuUsxTu1LnyCLP3eu+stu6k2pCydqbZl5iCOwZviDzAA9UJ9w7zXK0q5A1Zm/NequuReNicPl40NZy4X6rswGcnqN4lXmu1dcoSVbo+g;
Date: Tue, 16 Nov 2010 09:18:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI critical fix
Message-ID: <20101116091806.59138b90@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Arg I broke -rc2.  Martin made a change to his mmap check fix patch (a change
that I requested) and of course that ended up introducing a bug.  Darrick
caught it and fixed it quickly but not before you were able to release -rc2
onto an unsuspecting world.  My fault for not testing properly.

Darrick J. Wong (1):
      PCI: fix offset check for sysfs mmapped files

 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
