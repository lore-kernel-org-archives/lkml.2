Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2KQAbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2KQAbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:31:39 -0500
Date: Fri, 16 Nov 2012 22:31:24 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] more KVM fixes for 3.7-rc5 
Message-ID: <20121117003124.GA9033@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: ~/inbox/sent-mutt-Aug-2012
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive a correction for oops on module init with older Intel hosts.

Takashi Iwai (1):
      KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()

 arch/x86/kvm/vmx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)
