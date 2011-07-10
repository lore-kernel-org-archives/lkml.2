Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1GJB0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 21:26:25 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57294 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751467Ab1GJB0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 21:26:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TvRRXBFvR7bibxG3Yj2e+FerbgmBRqAqpi7UxQq6QURnK9CxG9QpG04uREV5Yr3bsd0XBVOxuNzOkNXYv8dzZpLxnKGcNN+OH+gnvgOgro5svUjjUS7HZXYuoacl5f1s;
Date: Sat, 9 Jul 2011 18:26:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20110709182619.1699a03a@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
a2fa83faf47b514ab947cea916d3691b66525073:

  Merge branch 'usb-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6 (2011-07-05 20:57:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one fix we discussed to get us back to old allocation behavior.
The new code is pretty close (we've only had a couple of reports of
problems) but not quite there yet.

Ram Pai (1):
      PCI: conditional resource-reallocation through kernel parameter pci=realloc

 Documentation/kernel-parameters.txt |    2 ++
 drivers/pci/pci.c                   |    2 ++
 drivers/pci/pci.h                   |    2 ++
 drivers/pci/setup-bus.c             |   15 +++++++++++++++
 4 files changed, 21 insertions(+), 0 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
