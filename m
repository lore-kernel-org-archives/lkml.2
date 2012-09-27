Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab2I0Ln3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:43:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51595 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2I0Ln1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:43:27 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: trivial@vger.kernel.org
Cc: perex@perex.cz, tiwai@suse.de, rusty@rustcorp.com.au,
        peter.senna@gmail.com, paul.gortmaker@windriver.com,
        eblennerhassett@audioscience.com, superquad.vortex2@gmail.com,
        den@openvz.org, kozerkov@parallels.com, axel.lin@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] sound: Remove unnecessary semicolon
Date: Thu, 27 Sep 2012 13:43:18 +0200
Message-Id: <1348746198-26375-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary semicolon

And:
sound/drivers/vx/vx_pcm.c: Convert spaces into tab

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 sound/drivers/opl3/opl3_midi.c        |  2 +-
 sound/drivers/vx/vx_pcm.c             |  2 +-
 sound/isa/sb/emu8000_callback.c       |  2 +-
 sound/isa/wavefront/wavefront_synth.c |  2 +-
 sound/oss/audio.c                     |  2 +-
 sound/oss/opl3.c                      |  2 +-
 sound/oss/pss.c                       |  2 +-
 sound/oss/sb_ess.c                    | 22 +++++++++++-----------
 sound/oss/sb_mixer.c                  |  4 ++--
 sound/oss/sys_timer.c                 |  4 ++--
 sound/oss/uart6850.c                  |  2 +-
 sound/pci/asihpi/asihpi.c             |  2 +-
 sound/pci/au88x0/au88x0_game.c        |  2 +-
 sound/pci/au88x0/au88x0_pcm.c         |  2 +-
 sound/pci/emu10k1/emu10k1_callback.c  |  2 +-
 sound/pci/emu10k1/emupcm.c            |  2 +-
 sound/pci/intel8x0.c                  |  2 +-
 sound/pci/mixart/mixart_hwdep.c       |  2 +-
 sound/sparc/amd7930.c                 |  4 ++--
 sound/sparc/dbri.c                    |  2 +-
 20 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/sound/drivers/opl3/opl3_midi.c b/sound/drivers/opl3/opl3_midi.c
index 2bfe4bc..0c796bc 100644
--- a/sound/drivers/opl3/opl3_midi.c
+++ b/sound/drivers/opl3/opl3_midi.c
@@ -163,7 +163,7 @@ static int opl3_get_voice(struct snd_opl3 *opl3, int instr_4op,
 	struct best *bp;
 
 	for (i = 0; i < END; i++) {
-		best[i].time = (unsigned int)(-1); /* XXX MAX_?INT really */;
+		best[i].time = (unsigned int)(-1); /* XXX MAX_?INT really */
 		best[i].voice = -1;
 	}
 
diff --git a/sound/drivers/vx/vx_pcm.c b/sound/drivers/vx/vx_pcm.c
index 5e897b2..deed5ef 100644
--- a/sound/drivers/vx/vx_pcm.c
+++ b/sound/drivers/vx/vx_pcm.c
@@ -184,7 +184,7 @@ static int vx_set_format(struct vx_core *chip, struct vx_pipe *pipe,
 	default : 
 		snd_BUG();
 		return -EINVAL;
-        };
+	}
 
 	return vx_set_stream_format(chip, pipe, header);
 }
diff --git a/sound/isa/sb/emu8000_callback.c b/sound/isa/sb/emu8000_callback.c
index 344b435..72a9ac5 100644
--- a/sound/isa/sb/emu8000_callback.c
+++ b/sound/isa/sb/emu8000_callback.c
@@ -175,7 +175,7 @@ get_voice(struct snd_emux *emu, struct snd_emux_port *port)
 	hw = emu->hw;
 
 	for (i = 0; i < END; i++) {
-		best[i].time = (unsigned int)(-1); /* XXX MAX_?INT really */;
+		best[i].time = (unsigned int)(-1); /* XXX MAX_?INT really */
 		best[i].voice = -1;
 	}
 
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index 405f8b6..b1bf8d4 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -538,7 +538,7 @@ munge_int32 (unsigned int src,
 	                            /* Note: we leave the upper bits in place */ 
 
 		dst++;
- 	};
+	}
 	return dst;
 };
 
diff --git a/sound/oss/audio.c b/sound/oss/audio.c
index 4b958b1..09c932f 100644
--- a/sound/oss/audio.c
+++ b/sound/oss/audio.c
@@ -354,7 +354,7 @@ int audio_read(int dev, struct file *file, char __user *buf, int count)
 
 			if(copy_to_user(&(buf)[p], fixit, l))
 				return -EFAULT;
-		};
+		}
 
 		DMAbuf_rmchars(dev, buf_no, l);
 
diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 407cd67..c5c2440 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -1190,7 +1190,7 @@ static int opl3_init(int ioaddr, struct module *owner)
 
 		for (i = 0; i < 18; i++)
 			pv_map[i].ioaddr = devc->left_io;
-	};
+	}
 	conf_printf2(devc->fm_info.name, ioaddr, 0, -1, -1);
 
 	for (i = 0; i < SBFM_MAXINSTR; i++)
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 0f32a56..145e36b 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -359,7 +359,7 @@ static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size
 		{
 			/*_____ Send the next byte */
 			outw (*block++, REG (PSS_DATA));
-		};
+		}
 		count++;
 	}
 
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 5c773df..c0be085 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -1104,15 +1104,15 @@ int ess_init(sb_devc * devc, struct address_info *hw_config)
 		default:
 			printk (KERN_ERR "Invalid esstype=%d specified\n", devc->sbmo.esstype);
 			return 0;
-		};
+		}
 		if (submodel != -1) {
 			devc->submodel = submodel;
 			sprintf (modelname, "ES%d", devc->sbmo.esstype);
 			chip = modelname;
-		};
+		}
 		if (chip == NULL && (ess_minor & 0x0f) < 8) {
 			chip = "ES688";
-		};
+		}
 #ifdef FKS_TEST
 FKS_test (devc);
 #endif
@@ -1122,7 +1122,7 @@ FKS_test (devc);
 		 */
 		if (chip == NULL && devc->sbmo.esstype == ESSTYPE_LIKE20) {
 			chip = "ES1688";
-		};
+		}
 
 		if (chip == NULL) {
 			int type;
@@ -1150,8 +1150,8 @@ FKS_test (devc);
 				if ((type & 0x00ff) != ((type >> 8) & 0x00ff)) {
 					printk ("ess_init: Unrecognized %04x\n", type);
 				}
-			};
-		};
+			}
+		}
 #if 0
 		/*
 		 * this one failed:
@@ -1182,10 +1182,10 @@ FKS_test (devc);
 				chip = "ES1788";
 				devc->submodel = SUBMDL_ES1788;
 			}
-		};
+		}
 		if (chip == NULL) {
 			chip = "ES1688";
-		};
+		}
 
 	    printk ( KERN_INFO "ESS chip %s %s%s\n"
                , chip
@@ -1293,7 +1293,7 @@ printk(KERN_INFO "ess_set_dma_hw: dma8=%d,dma16=%d,dup=%d\n"
 			default:
 				printk(KERN_ERR "ESS1887: Invalid DMA16 %d\n", dma);
 				return 0;
-			};
+			}
 			ess_chgmixer (devc, 0x78, 0x20, dma16_bits);
 			ess_chgmixer (devc, 0x7d, 0x07, dma_bits);
 		}
@@ -1584,7 +1584,7 @@ printk(KERN_INFO "FKS: write mixer %x: %x\n", port, value);
 		udelay(20);
 		outb(((unsigned char) (value & 0xff)), MIXER_DATA);
 		udelay(20);
-	};
+	}
 	spin_unlock_irqrestore(&devc->lock, flags);
 }
 
@@ -1761,7 +1761,7 @@ int ess_mixer_reset (sb_devc * devc)
 			ess_chgmixer(devc, 0x7a, 0x18, 0x08);
 			ess_chgmixer(devc, 0x1c, 0x07, 0x07);
 			break;
-		};
+		}
 		/*
 		 * Call set_recmask for proper initialization
 		 */
diff --git a/sound/oss/sb_mixer.c b/sound/oss/sb_mixer.c
index f8f3b7a..acf7586 100644
--- a/sound/oss/sb_mixer.c
+++ b/sound/oss/sb_mixer.c
@@ -410,7 +410,7 @@ static int set_recmask(sb_devc * devc, int mask)
 		case MDL_SMW:
 			if (devc->model == MDL_ESS && ess_set_recmask (devc, &devmask)) {
 				break;
-			};
+			}
 			if (devmask != SOUND_MASK_MIC &&
 				devmask != SOUND_MASK_LINE &&
 				devmask != SOUND_MASK_CD)
@@ -666,7 +666,7 @@ static void sb_mixer_reset(sb_devc * devc)
 
 	if (devc->model != MDL_ESS || !ess_mixer_reset (devc)) {
 		set_recmask(devc, SOUND_MASK_MIC);
-	};
+	}
 }
 
 int sb_mixer_init(sb_devc * devc, struct module *owner)
diff --git a/sound/oss/sys_timer.c b/sound/oss/sys_timer.c
index 8db6aef..9f03983 100644
--- a/sound/oss/sys_timer.c
+++ b/sound/oss/sys_timer.c
@@ -57,7 +57,7 @@ poll_def_tmr(unsigned long dummy)
 		  {
 			  def_tmr.expires = (1) + jiffies;
 			  add_timer(&def_tmr);
-		  };
+		  }
 
 		  if (tmr_running)
 		    {
@@ -103,7 +103,7 @@ def_tmr_open(int dev, int mode)
 	{
 		def_tmr.expires = (1) + jiffies;
 		add_timer(&def_tmr);
-	};
+	}
 
 	return 0;
 }
diff --git a/sound/oss/uart6850.c b/sound/oss/uart6850.c
index f3f914a..1079133 100644
--- a/sound/oss/uart6850.c
+++ b/sound/oss/uart6850.c
@@ -146,7 +146,7 @@ static int uart6850_open(int dev, int mode,
 	{
 /*		  printk("Midi6850: Midi busy\n");*/
 		  return -EBUSY;
-	};
+	}
 
 	uart6850_cmd(UART_RESET);
 	uart6850_input_loop();
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index a51e3ce..eedc017 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -2658,7 +2658,7 @@ static int __devinit snd_card_asihpi_mixer_new(struct snd_card_asihpi *asihpi)
 					hpi_ctl.dst_node_type,
 					hpi_ctl.dst_node_index);
 			continue;
-		};
+		}
 		if (err < 0)
 			return err;
 	}
diff --git a/sound/pci/au88x0/au88x0_game.c b/sound/pci/au88x0/au88x0_game.c
index c07c792..30a4567 100644
--- a/sound/pci/au88x0/au88x0_game.c
+++ b/sound/pci/au88x0/au88x0_game.c
@@ -100,7 +100,7 @@ static int __devinit vortex_gameport_register(vortex_t * vortex)
 	if (!gp) {
 		printk(KERN_ERR "vortex: cannot allocate memory for gameport\n");
 		return -ENOMEM;
-	};
+	}
 
 	gameport_set_name(gp, "AU88x0 Gameport");
 	gameport_set_phys(gp, "pci%s/gameport0", pci_name(vortex->pci_dev));
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index e59f120..b240502 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -585,7 +585,7 @@ static int snd_vortex_pcm_vol_put(struct snd_kcontrol *kcontrol,
 				case 4:
 					mixin = p->mixin[i];
 					break;
-				};
+				}
 				vol = p->vol[i];
 				vortex_mix_setinputvolumebyte(vortex,
 					vortex->mixplayb[i], mixin, vol);
diff --git a/sound/pci/emu10k1/emu10k1_callback.c b/sound/pci/emu10k1/emu10k1_callback.c
index a0afa50..cae3659 100644
--- a/sound/pci/emu10k1/emu10k1_callback.c
+++ b/sound/pci/emu10k1/emu10k1_callback.c
@@ -228,7 +228,7 @@ lookup_voices(struct snd_emux *emu, struct snd_emu10k1 *hw,
 	int  i;
 
 	for (i = 0; i < V_END; i++) {
-		best[i].time = (unsigned int)-1; /* XXX MAX_?INT really */;
+		best[i].time = (unsigned int)-1; /* XXX MAX_?INT really */
 		best[i].voice = -1;
 	}
 
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index e22b8e2..0e6664f 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1310,7 +1310,7 @@ static int snd_emu10k1_capture_efx_open(struct snd_pcm_substream *substream)
 			runtime->hw.channels_min =
 				runtime->hw.channels_max = 16;
 			break;
-		};
+		}
 #endif
 #if 0
 		/* For 96kHz */
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 848102e..ea4b706 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2226,7 +2226,7 @@ static int __devinit snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 		case DEVICE_INTEL_ICH4:
 			chip->spdif_idx = ICHD_SPBAR;
 			break;
-		};
+		}
 	}
 
 	chip->in_ac97_init = 1;
diff --git a/sound/pci/mixart/mixart_hwdep.c b/sound/pci/mixart/mixart_hwdep.c
index bfbdc91..e0f4d87 100644
--- a/sound/pci/mixart/mixart_hwdep.c
+++ b/sound/pci/mixart/mixart_hwdep.c
@@ -538,7 +538,7 @@ static int mixart_dsp_load(struct mixart_mgr* mgr, int index, const struct firmw
 
 		if ((err = snd_card_register(chip->card)) < 0)
 			return err;
-	};
+	}
 
 	snd_printdd("miXart firmware downloaded and successfully set up\n");
 
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index b63b3a8..5701787 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -813,7 +813,7 @@ static int snd_amd7930_get_volume(struct snd_kcontrol *kctl, struct snd_ctl_elem
 	default:
 		swval = &amd->pgain;
 		break;
-	};
+	}
 
 	ucontrol->value.integer.value[0] = *swval;
 
@@ -838,7 +838,7 @@ static int snd_amd7930_put_volume(struct snd_kcontrol *kctl, struct snd_ctl_elem
 	default:
 		swval = &amd->pgain;
 		break;
-	};
+	}
 
 	spin_lock_irqsave(&amd->lock, flags);
 
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index a6b0deb..ae35f53 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -592,7 +592,7 @@ static __u32 reverse_bytes(__u32 b, int len)
 		break;
 	default:
 		printk(KERN_ERR "DBRI reverse_bytes: unsupported length\n");
-	};
+	}
 
 	return b;
 }
-- 
1.7.11.4

