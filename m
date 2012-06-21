Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab2FUTTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:19:15 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2990 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759893Ab2FUTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:19:14 -0400
Message-ID: <1340306352.1773.58.camel@x61.thuisdomein>
Subject: [PATCH 0/3] Remove useless wrappers of headers in asm-generic
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 21:19:12 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jun 2012 19:19:12.0798 (UTC) FILETIME=[BDBB3BE0:01CD4FE2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) This short series removes useless wrappers of headers that are
incorrectly assumed to be present in include/asm-generic.

1) I've grouped this series per non-existent header. And I've chosen to
treat these patches as Kbuild patches and sent this series firstly to
Michal (and only secondly to the people involved with the various arches
this short series hits). Kbuild is the common theme in this series. I
assume Michal will shout if this choice is incorrect.

2) None of these patches are tested. I do not have the required
toolchains at hand. A further problem for me is that x86 (which I'm
familiar with) doesn't use Kbuild's generic-y trick. The patches look
innocent to me, but perhaps they hit some unobvious traps ...

Paul Bolle (3):
  Remove useless wrappers of asm-generic/cpumask.h
  Remove useless wrappers of asm-generic/ipc.h
  Remove useless wrappers of asm-generic/rmap.h

 arch/frv/include/asm/cpumask.h    |    6 ------
 arch/hexagon/include/asm/Kbuild   |    2 --
 arch/mn10300/include/asm/ipc.h    |    1 -
 arch/openrisc/include/asm/Kbuild  |    2 --
 arch/tile/include/asm/Kbuild      |    1 -
 arch/xtensa/include/asm/cpumask.h |   16 ----------------
 arch/xtensa/include/asm/rmap.h    |   16 ----------------
 7 files changed, 0 insertions(+), 44 deletions(-)
 delete mode 100644 arch/frv/include/asm/cpumask.h
 delete mode 100644 arch/mn10300/include/asm/ipc.h
 delete mode 100644 arch/xtensa/include/asm/cpumask.h
 delete mode 100644 arch/xtensa/include/asm/rmap.h

-- 
1.7.7.6

