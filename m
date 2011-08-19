Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1HSRUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:20:05 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36393 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755531Ab1HSRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:20:00 -0400
Date: Fri, 19 Aug 2011 10:19:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20110819101952.43c44ddd@jbarnes-desktop>
In-Reply-To: <20110819101224.5e188af7@jbarnes-desktop>
References: <20110819091749.091dd1cb@jbarnes-desktop>
	<20110819164654.GA4016@kroah.com>
	<20110819101224.5e188af7@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 10:12:24 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Fri, 19 Aug 2011 09:46:54 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Aug 19, 2011 at 09:17:49AM -0700, Jesse Barnes wrote:
> > > The following changes since commit
> > > 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453:
> > > 
> > >   Merge branch 'for-linus' of
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
> > >   (2011-08-18 14:20:00 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 ..BRANCH.NOT.VERIFIED..
> > 
> > I think that branch name is not correct :)
> 
> Yeah a pull from that probably won't work will it?
> 
> for-linus is the branch name, sorry.

Here's the pull req for master.kernel.org so you know what to expect.
Looks like the mirroring is taking longer than usual right now.

The following changes since commit 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable (2011-08-18 14:20:00 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

David Daney (1):
      PCI: OF: Don't crash when bridge parent is NULL.

Jon Mason (2):
      PCI: Set PCI-E Max Payload Size on fabric
      PCI: export pcie_bus_configure_settings symbol

Ram Pai (3):
      PCI : ability to relocate assigned pci-resources
      PCI: make cardbus-bridge resources optional
      PCI: code and comments cleanup

Yinghai Lu (2):
      PCI: honor child buses add_size in hot plug configuration
      PCI: make SRIOV resources optional

 arch/x86/pci/acpi.c              |    9 ++
 drivers/pci/hotplug/pcihp_slot.c |   45 +----------
 drivers/pci/of.c                 |    2 +-
 drivers/pci/pci.c                |   67 +++++++++++++++
 drivers/pci/pci.h                |    4 +
 drivers/pci/probe.c              |  146 +++++++++++++++++++++++++++++++++
 drivers/pci/setup-bus.c          |  166 ++++++++++++++++++++++++++-----------
 drivers/pci/setup-res.c          |  152 ++++++++++++++++++++++-------------
 include/linux/pci.h              |   16 ++++-
 9 files changed, 454 insertions(+), 153 deletions(-)
