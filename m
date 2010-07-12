Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0GLU5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:57:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1725 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0GLUue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 03/36] arch/powerpc: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:55 -0700
Message-Id: <d0c55635c673debb83f0d45d77e5a5187aea4f2f.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kvm/timing.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
index 7037855..46fa04f 100644
--- a/arch/powerpc/kvm/timing.c
+++ b/arch/powerpc/kvm/timing.c
@@ -182,7 +182,7 @@ static ssize_t kvmppc_exit_timing_write(struct file *file,
 	}
 
 	if (c == 'c') {
-		struct seq_file *seqf = (struct seq_file *)file->private_data;
+		struct seq_file *seqf = file->private_data;
 		struct kvm_vcpu *vcpu = seqf->private;
 		/* Write does not affect our buffers previously generated with
 		 * show. seq_file is locked here to prevent races of init with
-- 
1.7.1.337.g6068.dirty

