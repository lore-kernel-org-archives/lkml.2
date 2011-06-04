Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1FDApm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:45:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2511 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab1FDApj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:45:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] sparc: Remove unnecessary semicolons
Date: Fri,  3 Jun 2011 17:45:23 -0700
Message-Id: <6249a3b9b6716eb774d4c7958c259e5e2d43d642.1307148187.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semicolons are not necessary after switch/while/for/if braces
so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sparc/include/asm/floppy_32.h |    8 ++++----
 arch/sparc/include/asm/floppy_64.h |    4 ++--
 arch/sparc/include/asm/system_32.h |    2 +-
 arch/sparc/include/asm/system_64.h |    2 +-
 arch/sparc/kernel/apc.c            |    2 +-
 arch/sparc/kernel/auxio_32.c       |    2 +-
 arch/sparc/kernel/chmc.c           |    2 +-
 arch/sparc/kernel/module.c         |    2 +-
 arch/sparc/kernel/pci_common.c     |    4 ++--
 arch/sparc/kernel/pci_schizo.c     |    6 +++---
 arch/sparc/kernel/prom_irqtrans.c  |    2 +-
 arch/sparc/kernel/psycho_common.c  |    2 +-
 arch/sparc/kernel/sbus.c           |    4 ++--
 arch/sparc/kernel/setup_32.c       |    2 +-
 arch/sparc/kernel/setup_64.c       |    2 +-
 arch/sparc/kernel/smp_32.c         |    6 +++---
 arch/sparc/kernel/sys_sparc32.c    |    2 +-
 arch/sparc/kernel/sys_sparc_64.c   |    6 +++---
 arch/sparc/kernel/time_64.c        |    2 +-
 arch/sparc/kernel/traps_64.c       |    2 +-
 arch/sparc/kernel/unaligned_64.c   |    6 +++---
 arch/sparc/kernel/us2e_cpufreq.c   |    6 +++---
 arch/sparc/kernel/us3_cpufreq.c    |    4 ++--
 arch/sparc/kernel/viohs.c          |    2 +-
 arch/sparc/kernel/visemul.c        |   14 +++++++-------
 arch/sparc/mm/fault_32.c           |    2 +-
 arch/sparc/mm/init_32.c            |    2 +-
 arch/sparc/mm/init_64.c            |    6 +++---
 arch/sparc/mm/srmmu.c              |    4 ++--
 arch/sparc/mm/sun4c.c              |    8 ++++----
 arch/sparc/mm/tsb.c                |    6 +++---
 arch/sparc/prom/console_32.c       |    2 +-
 arch/sparc/prom/init_32.c          |    2 +-
 arch/sparc/prom/mp.c               |    2 +-
 34 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/arch/sparc/include/asm/floppy_32.h b/arch/sparc/include/asm/floppy_32.h
index 482c79e..7440915 100644
--- a/arch/sparc/include/asm/floppy_32.h
+++ b/arch/sparc/include/asm/floppy_32.h
@@ -138,7 +138,7 @@ static unsigned char sun_82072_fd_inb(int port)
 		return sun_fdc->data_82072;
 	case 7: /* FD_DIR */
 		return sun_read_dir();
-	};
+	}
 	panic("sun_82072_fd_inb: How did I get here?");
 }
 
@@ -161,7 +161,7 @@ static void sun_82072_fd_outb(unsigned char value, int port)
 	case 4: /* FD_STATUS */
 		sun_fdc->status_82072 = value;
 		break;
-	};
+	}
 	return;
 }
 
@@ -186,7 +186,7 @@ static unsigned char sun_82077_fd_inb(int port)
 		return sun_fdc->data_82077;
 	case 7: /* FD_DIR */
 		return sun_read_dir();
-	};
+	}
 	panic("sun_82077_fd_inb: How did I get here?");
 }
 
@@ -212,7 +212,7 @@ static void sun_82077_fd_outb(unsigned char value, int port)
 	case 3: /* FD_TDR */
 		sun_fdc->tapectl_82077 = value;
 		break;
-	};
+	}
 	return;
 }
 
diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index 6597ce8..bcef1f5 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -111,7 +111,7 @@ static unsigned char sun_82077_fd_inb(unsigned long port)
 	case 7: /* FD_DIR */
 		/* XXX: Is DCL on 0x80 in sun4m? */
 		return sbus_readb(&sun_fdc->dir_82077);
-	};
+	}
 	panic("sun_82072_fd_inb: How did I get here?");
 }
 
@@ -135,7 +135,7 @@ static void sun_82077_fd_outb(unsigned char value, unsigned long port)
 	case 4: /* FD_STATUS */
 		sbus_writeb(value, &sun_fdc->status_82077);
 		break;
-	};
+	}
 	return;
 }
 
diff --git a/arch/sparc/include/asm/system_32.h b/arch/sparc/include/asm/system_32.h
index 47a7e86..aba1609 100644
--- a/arch/sparc/include/asm/system_32.h
+++ b/arch/sparc/include/asm/system_32.h
@@ -220,7 +220,7 @@ static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr, int
 	switch (size) {
 	case 4:
 		return xchg_u32(ptr, x);
-	};
+	}
 	__xchg_called_with_bad_pointer();
 	return x;
 }
diff --git a/arch/sparc/include/asm/system_64.h b/arch/sparc/include/asm/system_64.h
index 3c96d3b..10bcabc 100644
--- a/arch/sparc/include/asm/system_64.h
+++ b/arch/sparc/include/asm/system_64.h
@@ -234,7 +234,7 @@ static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr,
 		return xchg32(ptr, x);
 	case 8:
 		return xchg64(ptr, x);
-	};
+	}
 	__xchg_called_with_bad_pointer();
 	return x;
 }
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 1e34f29..caef9de 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -123,7 +123,7 @@ static long apc_ioctl(struct file *f, unsigned int cmd, unsigned long __arg)
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/arch/sparc/kernel/auxio_32.c b/arch/sparc/kernel/auxio_32.c
index 8505e0a..acf5151 100644
--- a/arch/sparc/kernel/auxio_32.c
+++ b/arch/sparc/kernel/auxio_32.c
@@ -101,7 +101,7 @@ void set_auxio(unsigned char bits_on, unsigned char bits_off)
 		break;
 	default:
 		panic("Can't set AUXIO register on this machine.");
-	};
+	}
 	spin_unlock_irqrestore(&auxio_lock, flags);
 }
 EXPORT_SYMBOL(set_auxio);
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index 668c7be..5f45026 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -664,7 +664,7 @@ static void chmc_interpret_one_decode_reg(struct chmc *p, int which_bank, u64 va
 	case 0x0:
 		bp->interleave = 16;
 		break;
-	};
+	}
 
 	/* UK[10] is reserved, and UK[11] is not set for the SDRAM
 	 * bank size definition.
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 8d348c4..99ba5ba 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -214,7 +214,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			       me->name,
 			       (int) (ELF_R_TYPE(rel[i].r_info) & 0xff));
 			return -ENOEXEC;
-		};
+		}
 	}
 	return 0;
 }
diff --git a/arch/sparc/kernel/pci_common.c b/arch/sparc/kernel/pci_common.c
index 6e3874b..a689598 100644
--- a/arch/sparc/kernel/pci_common.c
+++ b/arch/sparc/kernel/pci_common.c
@@ -281,7 +281,7 @@ static int sun4v_read_pci_cfg(struct pci_bus *bus_dev, unsigned int devfn,
 	case 4:
 		*value = ret & 0xffffffff;
 		break;
-	};
+	}
 
 
 	return PCIBIOS_SUCCESSFUL;
@@ -456,7 +456,7 @@ void pci_determine_mem_io_space(struct pci_pbm_info *pbm)
 
 		default:
 			break;
-		};
+		}
 	}
 
 	if (!saw_io || !saw_mem) {
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 283fbc3..f030b02 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -264,7 +264,7 @@ static void schizo_check_iommu_error_pbm(struct pci_pbm_info *pbm,
 		default:
 			type_string = "ECC Error";
 			break;
-		};
+		}
 		printk("%s: IOMMU Error, type[%s]\n",
 		       pbm->name, type_string);
 
@@ -319,7 +319,7 @@ static void schizo_check_iommu_error_pbm(struct pci_pbm_info *pbm,
 			default:
 				type_string = "ECC Error";
 				break;
-			};
+			}
 			printk("%s: IOMMU TAG(%d)[error(%s) ctx(%x) wr(%d) str(%d) "
 			       "sz(%dK) vpg(%08lx)]\n",
 			       pbm->name, i, type_string,
@@ -1328,7 +1328,7 @@ static int __devinit schizo_pbm_init(struct pci_pbm_info *pbm,
 	default:
 		chipset_name = "SCHIZO";
 		break;
-	};
+	}
 
 	/* For SCHIZO, three OBP regs:
 	 * 1) PBM controller regs
diff --git a/arch/sparc/kernel/prom_irqtrans.c b/arch/sparc/kernel/prom_irqtrans.c
index 570b98f..40e4936 100644
--- a/arch/sparc/kernel/prom_irqtrans.c
+++ b/arch/sparc/kernel/prom_irqtrans.c
@@ -694,7 +694,7 @@ static unsigned int sbus_of_build_irq(struct device_node *dp,
 		case 3:
 			iclr = reg_base + SYSIO_ICLR_SLOT3;
 			break;
-		};
+		}
 
 		iclr += ((unsigned long)sbus_level - 1UL) * 8UL;
 	}
diff --git a/arch/sparc/kernel/psycho_common.c b/arch/sparc/kernel/psycho_common.c
index fe2af66..8db48e8 100644
--- a/arch/sparc/kernel/psycho_common.c
+++ b/arch/sparc/kernel/psycho_common.c
@@ -228,7 +228,7 @@ void psycho_check_iommu_error(struct pci_pbm_info *pbm,
 		default:
 			type_str = "ECC Error";
 			break;
-		};
+		}
 		printk(KERN_ERR "%s: IOMMU Error, type[%s]\n",
 		       pbm->name, type_str);
 
diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index 2ca32d1..a161b9c 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -97,7 +97,7 @@ void sbus_set_sbus64(struct device *dev, int bursts)
 
 	default:
 		return;
-	};
+	}
 
 	val = upa_readq(cfg_reg);
 	if (val & (1UL << 14UL)) {
@@ -244,7 +244,7 @@ static unsigned int sbus_build_irq(struct platform_device *op, unsigned int ino)
 		case 3:
 			iclr = reg_base + SYSIO_ICLR_SLOT3;
 			break;
-		};
+		}
 
 		iclr += ((unsigned long)sbus_level - 1UL) * 8UL;
 	}
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index 3249d3f..d26e1f6 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -267,7 +267,7 @@ void __init setup_arch(char **cmdline_p)
 	default:
 		printk("UNKNOWN!\n");
 		break;
-	};
+	}
 
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index f3b6850..c4dd099 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -209,7 +209,7 @@ void __init per_cpu_patch(void)
 		default:
 			prom_printf("Unknown cpu type, halting.\n");
 			prom_halt();
-		};
+		}
 
 		*(unsigned int *) (addr +  0) = insns[0];
 		wmb();
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index d5b3958..21b1253 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -114,7 +114,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 }
 
 void cpu_panic(void)
@@ -374,7 +374,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 }
 
 /* Set this up early so that things like the scheduler can init
@@ -447,7 +447,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 
 	if (!ret) {
 		cpumask_set_cpu(cpu, &smp_commenced_mask);
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 6db18c6..170cd8e 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -109,7 +109,7 @@ asmlinkage long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compa
 
 	default:
 		return -ENOSYS;
-	};
+	}
 
 	return -ENOSYS;
 }
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 96082d3..908b47a 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -460,7 +460,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	}
 	if (call <= MSGCTL) {
 		switch (call) {
@@ -481,7 +481,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	}
 	if (call <= SHMCTL) {
 		switch (call) {
@@ -507,7 +507,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	} else {
 		err = -ENOSYS;
 	}
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 2b8d54b..1db6b18 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -708,7 +708,7 @@ static void sparc64_timer_setup(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_UNUSED:
 		WARN_ON(1);
 		break;
-	};
+	}
 }
 
 static struct clock_event_device sparc64_clockevent = {
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 1ed547b..0cbdaa4 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -1804,7 +1804,7 @@ static const char *sun4v_err_type_to_str(u32 type)
 		return "warning resumable";
 	default:
 		return "unknown";
-	};
+	}
 }
 
 static void sun4v_log_error(struct pt_regs *regs, struct sun4v_error_entry *ent, int cpu, const char *pfx, atomic_t *ocnt)
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index c752c4c..b2b019e 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -211,7 +211,7 @@ static inline int do_int_store(int reg_num, int size, unsigned long *dst_addr,
 		default:
 			BUG();
 			break;
-		};
+		}
 	}
 	return __do_int_store(dst_addr, size, src_val, asi);
 }
@@ -328,7 +328,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 		case ASI_SNFL:
 			asi &= ~0x08;
 			break;
-		};
+		}
 		switch (dir) {
 		case load:
 			reg_addr = fetch_reg_addr(((insn>>25)&0x1f), regs);
@@ -351,7 +351,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 				default:
 					BUG();
 					break;
-				};
+				}
 				*reg_addr = val_in;
 			}
 			break;
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
index 531d54f..489fc15 100644
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -176,7 +176,7 @@ static unsigned long index_to_estar_mode(unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 }
 
 static unsigned long index_to_divisor(unsigned int index)
@@ -199,7 +199,7 @@ static unsigned long index_to_divisor(unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 }
 
 static unsigned long estar_to_divisor(unsigned long estar)
@@ -224,7 +224,7 @@ static unsigned long estar_to_divisor(unsigned long estar)
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	return ret;
 }
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
index 9a8ceb7..eb1624b 100644
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -71,7 +71,7 @@ static unsigned long get_current_freq(unsigned int cpu, unsigned long safari_cfg
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	return ret;
 }
@@ -125,7 +125,7 @@ static void us3_set_cpu_divider_index(unsigned int cpu, unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 
 	reg = read_safari_cfg();
 
diff --git a/arch/sparc/kernel/viohs.c b/arch/sparc/kernel/viohs.c
index aa6ac70..29348ea 100644
--- a/arch/sparc/kernel/viohs.c
+++ b/arch/sparc/kernel/viohs.c
@@ -363,7 +363,7 @@ static int process_ver(struct vio_driver_state *vio, struct vio_ver_info *pkt)
 
 	default:
 		return handshake_failure(vio);
-	};
+	}
 }
 
 static int process_attr(struct vio_driver_state *vio, void *pkt)
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 9dfd2eb..3635771 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -334,7 +334,7 @@ static void edge(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		left = edge32_tab_l[(rs1 >> 2) & 0x1].left;
 		right = edge32_tab_l[(rs2 >> 2) & 0x1].right;
 		break;
-	};
+	}
 
 	if ((rs1 & ~0x7UL) == (rs2 & ~0x7UL))
 		rd_val = right & left;
@@ -360,7 +360,7 @@ static void edge(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		tstate = regs->tstate & ~(TSTATE_XCC | TSTATE_ICC);
 		regs->tstate = tstate | (ccr << 32UL);
 	}
-	};
+	}
 }
 
 static void array(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -392,7 +392,7 @@ static void array(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 
 	case ARRAY32_OPF:
 		rd_val <<= 2;
-	};
+	}
 
 	store_reg(regs, rd_val, RD(insn));
 }
@@ -577,7 +577,7 @@ static void pformat(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		*fpd_regaddr(f, RD(insn)) = rd_val;
 		break;
 	}
-	};
+	}
 }
 
 static void pmul(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -693,7 +693,7 @@ static void pmul(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		*fpd_regaddr(f, RD(insn)) = rd_val;
 		break;
 	}
-	};
+	}
 }
 
 static void pcmp(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -786,7 +786,7 @@ static void pcmp(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 				rd_val |= 1 << i;
 		}
 		break;
-	};
+	}
 
 	maybe_flush_windows(0, 0, RD(insn), 0);
 	store_reg(regs, rd_val, RD(insn));
@@ -885,7 +885,7 @@ int vis_emul(struct pt_regs *regs, unsigned int insn)
 	case BSHUFFLE_OPF:
 		bshuffle(regs, insn);
 		break;
-	};
+	}
 
 	regs->tpc = regs->tnpc;
 	regs->tnpc += 4;
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index b10ac4d..7543ddb 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -135,7 +135,7 @@ asmlinkage int lookup_fault(unsigned long pc, unsigned long ret_pc,
 
 	default:
 		break;
-	};
+	}
 
 	memset(&regs, 0, sizeof (regs));
 	regs.pc = pc;
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index ca21732..7b00de6 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -340,7 +340,7 @@ void __init paging_init(void)
 		prom_printf("paging_init: sparc_cpu_model = %d\n", sparc_cpu_model);
 		prom_printf("paging_init: Halting...\n");
 		prom_halt();
-	};
+	}
 
 	/* Initialize the protection map with non-constant, MMU dependent values. */
 	protection_map[0] = PAGE_NONE;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index e10cd03..3fd8e18 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1625,7 +1625,7 @@ static void __init sun4v_ktsb_init(void)
 		ktsb_descr[0].pgsz_idx = HV_PGSZ_IDX_4MB;
 		ktsb_descr[0].pgsz_mask = HV_PGSZ_MASK_4MB;
 		break;
-	};
+	}
 
 	ktsb_descr[0].assoc = 1;
 	ktsb_descr[0].num_ttes = KERNEL_TSB_NENTRIES;
@@ -2266,7 +2266,7 @@ unsigned long pte_sz_bits(unsigned long sz)
 			return _PAGE_SZ512K_4V;
 		case 4 * 1024 * 1024:
 			return _PAGE_SZ4MB_4V;
-		};
+		}
 	} else {
 		switch (sz) {
 		case 8 * 1024:
@@ -2278,7 +2278,7 @@ unsigned long pte_sz_bits(unsigned long sz)
 			return _PAGE_SZ512K_4U;
 		case 4 * 1024 * 1024:
 			return _PAGE_SZ4MB_4U;
-		};
+		}
 	}
 }
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index fe09fd8..cbef74e 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1665,7 +1665,7 @@ static void __init init_swift(void)
 	default:
 		srmmu_modtype = Swift_ok;
 		break;
-	};
+	}
 
 	BTFIXUPSET_CALL(flush_cache_all, swift_flush_cache_all, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(flush_cache_mm, swift_flush_cache_mm, BTFIXUPCALL_NORM);
@@ -2069,7 +2069,7 @@ static void __init get_srmmu_type(void)
 			/* Some other Cypress revision, assume a 605. */
 			init_cypress_605(mod_rev);
 			break;
-		};
+		}
 		return;
 	}
 	
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index a2350b5..1cf4f19 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -318,7 +318,7 @@ void __init sun4c_probe_vac(void)
 		prom_printf("probe_vac: Didn't expect vac-linesize of %d, halting\n",
 			    sun4c_vacinfo.linesize);
 		prom_halt();
-	};
+	}
 
 	sun4c_flush_all();
 	sun4c_enable_vac();
@@ -364,7 +364,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Unhandled number of segmaps: %d\n",
 				    num_segmaps);
 			prom_halt();
-	};
+	}
 	switch (num_contexts) {
 		case 8:
 			/* Default, nothing to do. */
@@ -377,7 +377,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Unhandled number of contexts: %d\n",
 				    num_contexts);
 			prom_halt();
-	};
+	}
 
 	if (sun4c_vacinfo.do_hwflushes != 0) {
 		PATCH_INSN(vac_hwflush_patch1_on, vac_hwflush_patch1);
@@ -394,7 +394,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Impossible VAC linesize %d, halting...\n",
 				    sun4c_vacinfo.linesize);
 			prom_halt();
-		};
+		}
 	}
 }
 
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 9484615..a5f51b2 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -180,7 +180,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 		printk(KERN_ERR "TSB[%s:%d]: Impossible TSB size %lu, killing process.\n",
 		       current->comm, current->pid, tsb_bytes);
 		do_exit(SIGSEGV);
-	};
+	}
 	tte |= pte_sz_bits(page_sz);
 
 	if (tlb_type == cheetah_plus || tlb_type == hypervisor) {
@@ -215,7 +215,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 #endif
 		default:
 			BUG();
-		};
+		}
 		hp->assoc = 1;
 		hp->num_ttes = tsb_bytes / 16;
 		hp->ctx_idx = 0;
@@ -230,7 +230,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 #endif
 		default:
 			BUG();
-		};
+		}
 		hp->tsb_base = tsb_paddr;
 		hp->resv = 0;
 	}
diff --git a/arch/sparc/prom/console_32.c b/arch/sparc/prom/console_32.c
index b05e3db..a00f47b 100644
--- a/arch/sparc/prom/console_32.c
+++ b/arch/sparc/prom/console_32.c
@@ -38,7 +38,7 @@ static int prom_nbputchar(const char *buf)
 		break;
 	default:
 		break;
-	};
+	}
 	restore_current();
 	spin_unlock_irqrestore(&prom_lock, flags);
 	return i; /* Ugh, we could spin forever on unsupported proms ;( */
diff --git a/arch/sparc/prom/init_32.c b/arch/sparc/prom/init_32.c
index 0a601b3..26c64ce 100644
--- a/arch/sparc/prom/init_32.c
+++ b/arch/sparc/prom/init_32.c
@@ -53,7 +53,7 @@ void __init prom_init(struct linux_romvec *rp)
 			    romvec->pv_romvers);
 		prom_halt();
 		break;
-	};
+	}
 
 	prom_rev = romvec->pv_plugin_revision;
 	prom_prev = romvec->pv_printrev;
diff --git a/arch/sparc/prom/mp.c b/arch/sparc/prom/mp.c
index 97c44c9..0da8256 100644
--- a/arch/sparc/prom/mp.c
+++ b/arch/sparc/prom/mp.c
@@ -35,7 +35,7 @@ prom_startcpu(int cpunode, struct linux_prom_registers *ctable_reg, int ctx, cha
 	case PROM_V3:
 		ret = (*(romvec->v3_cpustart))(cpunode, (int) ctable_reg, ctx, pc);
 		break;
-	};
+	}
 	restore_current();
 	spin_unlock_irqrestore(&prom_lock, flags);
 
-- 
1.7.5.rc3.dirty

