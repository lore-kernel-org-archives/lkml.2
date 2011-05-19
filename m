Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1ESFTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:19:06 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60107 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752367Ab1ESFTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:19:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P+yx7xEVNwMqa2FJRBPGO2nme05c7iv85SJfC7sc8Tg8Nanj532RvMOCgKIfaOu4MBD+3j59Z4AWsuq4KeU5gUthS2vQB1nUTJZ8h4DxcS82rDkQ6v/07X7EQT2XuNK1;
Date: Wed, 18 May 2011 22:19:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: [git pull] Documentation: create Documentation/virtual/,
 move/update files
Message-Id: <20110518221901.c1765c47.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs.git  docs-move

to get these changes:

commit 61516587513c84ac26e68e3ab008dc6e965d0378
Author: Rob Landley <rob@landley.net>
Date:   Fri May 6 09:27:36 2011 -0700

    Correct occurrences of
    - Documentation/kvm/ to Documentation/virtual/kvm
    - Documentation/uml/ to Documentation/virtual/uml
    - Documentation/lguest/ to Documentation/virtual/lguest
    throughout the kernel source tree.
    
    Signed-off-by: Rob Landley <rob@landley.net>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

commit 570aa13a5dbea9b905b4cd6315aa6e1b3a9fd2f8
Author: Rob Landley <rlandley@parallels.com>
Date:   Fri May 6 09:23:23 2011 -0700

    Add a 00-INDEX file to Documentation/virtual
    Remove uml from the top level 00-INDEX file.
    
    Signed-off-by: Rob Landley <rlandley@parallels.com>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

commit ed16648eb5b86917f0b90bdcdbc857202da72f90
Author: Rob Landley <rlandley@parallels.com>
Date:   Fri May 6 09:22:02 2011 -0700

    Move kvm, uml, and lguest subdirectories under a common "virtual" directory,
    
      cd Documentation
      mkdir virtual
      git mv kvm uml lguest virtual
    
    Signed-off-by: Rob Landley <rlandley@parallels.com>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


 Documentation/00-INDEX                             |    2 --
 Documentation/virtual/00-INDEX                     |   10 ++++++++++
 Documentation/{ => virtual}/kvm/api.txt            |    0
 Documentation/{ => virtual}/kvm/cpuid.txt          |    0
 Documentation/{ => virtual}/kvm/locking.txt        |    0
 Documentation/{ => virtual}/kvm/mmu.txt            |    0
 Documentation/{ => virtual}/kvm/msr.txt            |    0
 Documentation/{ => virtual}/kvm/ppc-pv.txt         |    0
 .../{ => virtual}/kvm/review-checklist.txt         |    2 +-
 Documentation/{ => virtual}/kvm/timekeeping.txt    |    0
 Documentation/{ => virtual}/lguest/.gitignore      |    0
 Documentation/{ => virtual}/lguest/Makefile        |    0
 Documentation/{ => virtual}/lguest/extract         |    0
 Documentation/{ => virtual}/lguest/lguest.c        |    0
 Documentation/{ => virtual}/lguest/lguest.txt      |    3 ++-
 .../{ => virtual}/uml/UserModeLinux-HOWTO.txt      |    0
 MAINTAINERS                                        |    4 ++--
 arch/x86/lguest/boot.c                             |    2 +-
 drivers/lguest/Kconfig                             |    6 ++++--
 drivers/lguest/Makefile                            |    2 +-
 drivers/vhost/vhost.c                              |    2 +-
 21 files changed, 22 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/virtual/00-INDEX
 rename Documentation/{ => virtual}/kvm/api.txt (100%)
 rename Documentation/{ => virtual}/kvm/cpuid.txt (100%)
 rename Documentation/{ => virtual}/kvm/locking.txt (100%)
 rename Documentation/{ => virtual}/kvm/mmu.txt (100%)
 rename Documentation/{ => virtual}/kvm/msr.txt (100%)
 rename Documentation/{ => virtual}/kvm/ppc-pv.txt (100%)
 rename Documentation/{ => virtual}/kvm/review-checklist.txt (95%)
 rename Documentation/{ => virtual}/kvm/timekeeping.txt (100%)
 rename Documentation/{ => virtual}/lguest/.gitignore (100%)
 rename Documentation/{ => virtual}/lguest/Makefile (100%)
 rename Documentation/{ => virtual}/lguest/extract (100%)
 rename Documentation/{ => virtual}/lguest/lguest.c (100%)
 rename Documentation/{ => virtual}/lguest/lguest.txt (97%)
 rename Documentation/{ => virtual}/uml/UserModeLinux-HOWTO.txt (100%)
