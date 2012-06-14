Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2FNAvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2FNAvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:51:31 -0400
Date: Wed, 13 Jun 2012 21:51:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM update for 3.5-rc2
Message-ID: <20120614005124.GA25685@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive a spurious warning fix on CPU offline path.


Marcelo Tosatti (1):
      x86: kvmclock: remove check_and_clear_guest_paused warning

 arch/x86/kernel/kvmclock.c |    5 -----
 1 file changed, 5 deletions(-)



