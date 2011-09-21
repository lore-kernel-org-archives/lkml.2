Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1IUDzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:55:51 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38244 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1IUDzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:55:50 -0400
Date: Wed, 21 Sep 2011 13:55:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20110921135547.3b9f46eb225a694316158ae8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
include/linux/kvm.h between commit b6cf8788a338 ("[S390] kvm: extension
capability for new address space layout") from the s390 tree and commit
d36fe129f29a ("KVM: x86: Raise the hard VCPU count limit") from the kvm
tree.

Just context changes.  I fixed it up (see below) anc can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kvm.h
index aace6b8,55f5afb..0000000
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@@ -553,7 -553,7 +553,8 @@@ struct kvm_ppc_pvinfo 
  #define KVM_CAP_SPAPR_TCE 63
  #define KVM_CAP_PPC_SMT 64
  #define KVM_CAP_PPC_RMA	65
+ #define KVM_CAP_MAX_VCPUS 66       /* returns max vcpus per vm */
 +#define KVM_CAP_S390_GMAP 71
  
  #ifdef KVM_CAP_IRQ_ROUTING
  
