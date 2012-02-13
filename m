Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2BMUZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:25:45 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51097 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757967Ab2BMUZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:25:43 -0500
Message-ID: <1329164739.4939.14.camel@joe2Laptop>
Subject: [RFC] MAINTAINERS: Remove or update no longer existing git trees
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, "H. Peter Anvin" <hpa@zytor.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Len Brown <lenb@kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Patrick McHardy <kaber@trash.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Steve French <sfrench@samba.org>,
        Dave Kleikamp <shaggy@kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Date: Mon, 13 Feb 2012 12:25:39 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many git trees have not been restored to git.kernel.org
since the interruption of service last year.

Here's a list of currently non-existing kernel.org git
trees mentioned in MAINTAINERS:

T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-latest
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/irda-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

Update locations, make trees exist again (with better non-2.6 names)
or delete?

