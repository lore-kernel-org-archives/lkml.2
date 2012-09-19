Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2ISRIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:08:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2ISRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:08:08 -0400
Date: Wed, 19 Sep 2012 10:07:50 -0700
From: tip-bot for Peter Senna Tschudin <peter.senna@gmail.com>
Message-ID: <tip-4b8073e467e6a66b6a5a8e799d28bc3b243c0d78@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peter.senna@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com, tglx@linutronix.de
In-Reply-To: <1347986174-30287-7-git-send-email-peter.senna@gmail.com>
References: <1347986174-30287-7-git-send-email-peter.senna@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] arch/x86: Remove unecessary semicolons
Git-Commit-ID: 4b8073e467e6a66b6a5a8e799d28bc3b243c0d78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 10:07:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b8073e467e6a66b6a5a8e799d28bc3b243c0d78
Gitweb:     http://git.kernel.org/tip/4b8073e467e6a66b6a5a8e799d28bc3b243c0d78
Author:     Peter Senna Tschudin <peter.senna@gmail.com>
AuthorDate: Tue, 18 Sep 2012 18:36:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Sep 2012 17:32:48 +0200

arch/x86: Remove unecessary semicolons

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: avi@redhat.com
Cc: mtosatti@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: rusty@rustcorp.com.au
Cc: masami.hiramatsu.pt@hitachi.com
Cc: suresh.b.siddha@intel.com
Cc: joerg.roedel@amd.com
Cc: agordeev@redhat.com
Cc: yinghai@kernel.org
Cc: bhelgaas@google.com
Cc: liuj97@gmail.com
Link: http://lkml.kernel.org/r/1347986174-30287-7-git-send-email-peter.senna@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c  |    4 ++--
 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kvm/vmx.c             |    2 +-
 arch/x86/pci/mmconfig-shared.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ced4534..3318b1e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -317,7 +317,7 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 		/* turn DS segment override prefix into lock prefix */
 		if (*ptr == 0x3e)
 			text_poke(ptr, ((unsigned char []){0xf0}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
@@ -338,7 +338,7 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 		/* turn lock prefix into DS segment override prefix */
 		if (*ptr == 0xf0)
 			text_poke(ptr, ((unsigned char []){0x3E}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..b17416e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1934,7 +1934,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
 		i++;
 		v1 >>= 1;
-	};
+	}
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b1eb202..b06737d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4543,7 +4543,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 				vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
 				return 0;
 			}
-		};
+		}
 		break;
 	case 2: /* clts */
 		handle_clts(vcpu);
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 937bcec..704b9ec 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -585,7 +585,7 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
 	while (i >= sizeof(struct acpi_mcfg_allocation)) {
 		entries++;
 		i -= sizeof(struct acpi_mcfg_allocation);
-	};
+	}
 	if (entries == 0) {
 		pr_err(PREFIX "MMCONFIG has no entries\n");
 		return -ENODEV;
