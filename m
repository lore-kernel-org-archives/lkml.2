Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0FAVTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:19:30 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:21667 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753705Ab0FAVT2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:19:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 17:19:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3aRc4kBhzkGNDu8YBkbmwavGSpbdSB6mIArVm5HMXbPfjvqjEESsQeVhhFGVSaKOOg/HNSZVmO8apc3HlMn1NEVBxenuFcFTtZgeRKlLYsr3+Yfld95FY8mNtRL/T21J45TmbqPZ3qi84ZoKReL1fWiNqMAMd9YOxIlnXJHfBc4=;
Message-ID: <448702.76535.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: am7LRCoVM1l2ALrDLtgbPmaBlxsSm7ZyfUmivppmAlfdhEU
 4W4WhvsnZ0s.GssIv_TjncQbVEooQabMTcCgTkM4_QmHLy0XBIKk_XeBt1rm
 Ic3WtoLwu_ixN3Lk5cDjGXcT6Dg.TXbVRwbrVS6XE20H2d6jVPSpYCNl.COG
 HzQSOyEoN9nUNVxIr9FOA5imrFHmQ5TwlswymP9H1lYP5xHKN7I6KD3jIo2V
 nidO45RgPb7xM32P6iGG7SNvaEJcGRfIEA_QVxgrbhH3YhYm6o4sAwZzlcJ_
 3egq8F8ucLwb0JjzS_oXHIwaqpsDGa6Umx7MguXGiO3pmIi7tBezK.k6Zq2G
 YFBr9amTpIsKsbQ--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Tue, 1 Jun 2010 14:12:46 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [GIT PULL for 2.6.35] i7core/nehalem EDAC driver
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Bluesmoke ML <bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
In-Reply-To: <20100525124338.30bc22b4@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


acked-by: doug thompson <dougthompson@xmission.com>



--- On Tue, 5/25/10, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Subject: [GIT PULL for 2.6.35] i7core/nehalem EDAC driver
> To: "Linus Torvalds" <torvalds@linux-foundation.org>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "Doug Thompson" <dougthompson@xmission.com>, "Bluesmoke ML" <bluesmoke-devel@lists.sourceforge.net>, "Linux Edac Mailing List" <linux-edac@vger.kernel.org>
> Date: Tuesday, May 25, 2010, 9:43 AM
> Hi Linus,
> 
> I'm re-sending the pull request, as the previous branch
> were wrong.
> 
> Please pull from:
>  
> ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git
> linux_next
> 
> 
> The following changes since commit
> 66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8:
>   Linus Torvalds (1):
>         Linux 2.6.34-rc6
> 
> are available in the git repository at:
> 
>  
> ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git
> linux_next
> 
> Alan Cox (1):
>       edac: i7core_edac produces undefined
> behaviour on 32bit
> 
> Alexander Beregalov (1):
>       i7core_edac: fix memory leak of
> i7core_dev
> 
> Aristeu Rozanski (1):
>       pci: Add a probing code that seeks for
> an specific bus
> 
> Jiri Slaby (1):
>       EDAC: add __init to
> i7core_xeon_pci_fixup
> 
> Keith Mannthey (2):
>       i7core_edac: Fix ecc enable shift
>       i7core_edac: Probe on Xeons eariler
> 
> Mauro Carvalho Chehab (72):
>       i7core_edac: Add an EDAC memory
> controller driver for Nehalem chipsets
>       i7core_edac: Add error insertion code
> for Nehalem
>       i7core_edac: Add more status functions
> to EDAC driver
>       i7core_edac: Registers all supported
> MC functions
>       i7core_edac: Show read/write
> virtual/physical channel association
>       i7core_edac: A few fixes at error
> injection code
>       i7core_edac: need mci->edac_check,
> otherwise module removal doesn't work
>       i7core_edac: Add a memory check
> routine, based on device 3 function 4
>       i7core_edac: Add additional tests for
> error detection
>       i7core_edac: Properly fill struct
> csrow_info
>       i7core_edac: Improve error handling
>       i7core_edac: Add more information
> about each active dimm
>       i7core_edac: Get more info about the
> memory DIMMs
>       i7core_edac: Memory info fixes and
> preparation for properly filling cswrow data
>       i7core_edac: fill csrows edac sysfs
> info
>       i7core_edac: CodingStyle fixes
>       edac_mce: Add an interface driver to
> report mce errors via edac
>       edac/Kconfig: edac_mce can't be
> module
>       i7core_edac: Add edac_mce glue
>       i7core_edac: Adds write unlock to MC
> registers
>       i7core_edac: Add a code to probe Xeon
> 55xx bus
>       i7core_edac: add support for more than
> one MC socket
>       i7core_edac: maps all sockets as if
> ther are one MC controller
>       i7core_edac: decode mcelog error and
> send it via edac interface
>       i7core_edac: some fixes at memory
> error parser
>       i7core: fix probing on Xeon55xx
>       i7core: check if the memory error is
> fatal or non-fatal
>       i7core: enrich error information based
> on memory transaction type
>       i7core: fix get_devices routine for
> Xeon55xx
>       i7core: better document
> i7core_get_active_channels()
>       i7core: add socket info at the debug
> msg
>       i7core: remove some uneeded noisy
> debug messages
>       i7core_edac: Some cleanups at
> displayed info
>       i7core_edac: some fixes at error
> injection code
>       i7core_edac: fix error codes for sysfs
> error injection interface
>       i7core_edac: fix error injection
>       Documentation/edac.txt: Add Nehalem
> specific EDAC characteristics
>       i7core_edac: CodingSyle
> fixes/cleanups
>       i7core_edac: Print an error message if
> pci register fails
>       i7core_edac: Use Device 3 function 2
> to report errors with RDIMM's
>       i7core: Use registered memories per
> processor
>       i7core_edac: Improve
> corrected_error_counts output for RDIMM
>       i7core: temporary workaround to allow
> it to compile against 2.6.30
>       Dynamically allocate memory for PCI
> devices
>       i7core_edac: create one mc per
> socket/QPI
>       i7core_edac: sanity check: print a
> warning if a mcelog is ignored
>       i7core_edac: a few fixes for multiple
> mc's
>       Documentation/edac.txt: Improve it to
> reflect the latest changes at the driver
>       i7core_edac: Fix a bug when printing
> error counts with RDIMMs
>       i7core_edac: at remove, don't remove
> all pci devices at once
>       i7core_edac: remove static counter for
> max sockets
>       i7core_edac: change remove module
> strategy
>       i7core_edac: We need to use
> list_for_each_entry_safe to avoid errors
>       i7core_edac: Avoid printing a warning
> when debug is disabled
>       edac_core: Allow the creation of sysfs
> groups
>       i7core_edac: Add support for sysfs
> addrmatch group
>       edac: store/show methods for device
> groups weren't working
>       edac: Don't create csrow entries on
> instance groups
>       i7core_edac: Convert UDIMM error
> counters into a proper sysfs group
>       Documentation/edac.txt: Reflect the
> sysfs changes at the document
>       edac: Create an unique instance for
> each kobj
>       i7core_edac: Use a lockless
> ringbuffer
>       i7core_edac: Better parse "any"
> addrmask
>       i7core_edac: First store, then
> increment
>       i7core_edac: Fix ringbuffer maxsize
>       i7core_edac: PCI device is called
> NONCORE, instead of NOCORE
>       i7core_edac: Use a more generic
> approach for probing PCI devices
>       i7core_edac: Add initial support for
> Lynnfield
>       i7core: add support for Lynnfield
> alternate address
>       i7core_edac: Fix wrong device id for
> channel 1 devices
>       i7core_edac: Add support for X5670
>       i7core_edac: Better describe the
> supported devices
> 
> Randy Dunlap (1):
>       edac: fix i7core build
> 
> Stephen Rothwell (1):
>       i7core_edac: do not export static
> functions
> 
> Tony Luck (1):
>       i7core_edac: don't free on success
> 
> Vernon Mauery (2):
>       Always call
> i7core_[ur]dimm_check_mc_ecc_err
>       Add support for Westmere to
> i7core_edac driver
> 
>  Documentation/edac.txt       
>    |  152 +++
>  arch/x86/include/asm/pci_x86.h   | 
>   2 +
>  arch/x86/kernel/cpu/mcheck/mce.c |   10 +
>  arch/x86/pci/legacy.c         
>   |   42 +-
>  drivers/edac/Kconfig         
>    |   13 +
>  drivers/edac/Makefile         
>   |    2 +
>  drivers/edac/edac_core.h     
>    |   23 +-
>  drivers/edac/edac_mc_sysfs.c 
>    |  175 +++-
>  drivers/edac/edac_mce.c         
> |   61 ++
>  drivers/edac/i7core_edac.c   
>    | 2078
> ++++++++++++++++++++++++++++++++++++++
>  include/linux/edac_mce.h     
>    |   31 +
>  include/linux/pci.h         
>     |    1 +
>  include/linux/pci_ids.h         
> |   52 +
>  13 files changed, 2598 insertions(+), 44 deletions(-)
>  create mode 100644 drivers/edac/edac_mce.c
>  create mode 100644 drivers/edac/i7core_edac.c
>  create mode 100644 include/linux/edac_mce.h
> 
> 
> 
> -- 
> 
> Cheers,
> Mauro
> 
