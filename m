Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2KTR3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34976 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2KTR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:06 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 01/10] staging: cxt1e1: musycc.h: fixes indentation issues
Date: Tue, 20 Nov 2012 19:28:43 +0200
Message-Id: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes indentation issues that were reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/musycc.h |  226 +++++++++++++++++++--------------------
 1 file changed, 113 insertions(+), 113 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.h b/drivers/staging/cxt1e1/musycc.h
index cf6b54e..b6a282b 100644
--- a/drivers/staging/cxt1e1/musycc.h
+++ b/drivers/staging/cxt1e1/musycc.h
@@ -50,56 +50,56 @@
 /* RAM image of MUSYCC registers laid out as a C structure */
     struct musycc_groupr
     {
-        VINT32      thp[32];    /* Transmit Head Pointer [5-29]           */
-        VINT32      tmp[32];    /* Transmit Message Pointer [5-30]        */
-        VINT32      rhp[32];    /* Receive Head Pointer [5-29]            */
-        VINT32      rmp[32];    /* Receive Message Pointer [5-30]         */
-        VINT8       ttsm[128];  /* Time Slot Map [5-22]                   */
-        VINT8       tscm[256];  /* Subchannel Map [5-24]                  */
-        VINT32      tcct[32];   /* Channel Configuration [5-26]           */
-        VINT8       rtsm[128];  /* Time Slot Map [5-22]                   */
-        VINT8       rscm[256];  /* Subchannel Map [5-24]                  */
-        VINT32      rcct[32];   /* Channel Configuration [5-26]           */
-        VINT32      __glcd;     /* Global Configuration Descriptor [5-10] */
-        VINT32      __iqp;      /* Interrupt Queue Pointer [5-36]         */
-        VINT32      __iql;      /* Interrupt Queue Length [5-36]          */
-        VINT32      grcd;       /* Group Configuration Descriptor [5-16]  */
-        VINT32      mpd;        /* Memory Protection Descriptor [5-18]    */
-        VINT32      mld;        /* Message Length Descriptor [5-20]       */
-        VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
+	VINT32      thp[32];    /* Transmit Head Pointer [5-29]           */
+	VINT32      tmp[32];    /* Transmit Message Pointer [5-30]        */
+	VINT32      rhp[32];    /* Receive Head Pointer [5-29]            */
+	VINT32      rmp[32];    /* Receive Message Pointer [5-30]         */
+	VINT8       ttsm[128];  /* Time Slot Map [5-22]                   */
+	VINT8       tscm[256];  /* Subchannel Map [5-24]                  */
+	VINT32      tcct[32];   /* Channel Configuration [5-26]           */
+	VINT8       rtsm[128];  /* Time Slot Map [5-22]                   */
+	VINT8       rscm[256];  /* Subchannel Map [5-24]                  */
+	VINT32      rcct[32];   /* Channel Configuration [5-26]           */
+	VINT32      __glcd;     /* Global Configuration Descriptor [5-10] */
+	VINT32      __iqp;      /* Interrupt Queue Pointer [5-36]         */
+	VINT32      __iql;      /* Interrupt Queue Length [5-36]          */
+	VINT32      grcd;       /* Group Configuration Descriptor [5-16]  */
+	VINT32      mpd;        /* Memory Protection Descriptor [5-18]    */
+	VINT32      mld;        /* Message Length Descriptor [5-20]       */
+	VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
     };
 
 /* hardware MUSYCC registers laid out as a C structure */
     struct musycc_globalr
     {
-        VINT32      gbp;        /* Group Base Pointer                     */
-        VINT32      dacbp;      /* Dual Address Cycle Base Pointer        */
-        VINT32      srd;        /* Service Request Descriptor             */
-        VINT32      isd;        /* Interrupt Service Descriptor           */
-        /*
-         * adjust __thp due to above 4 registers, which are not contained
-         * within musycc_groupr[]. All __XXX[] are just place holders,
-         * anyhow.
-         */
-        VINT32      __thp[32 - 4];      /* Transmit Head Pointer [5-29]           */
-        VINT32      __tmp[32];  /* Transmit Message Pointer [5-30]        */
-        VINT32      __rhp[32];  /* Receive Head Pointer [5-29]            */
-        VINT32      __rmp[32];  /* Receive Message Pointer [5-30]         */
-        VINT8       ttsm[128];  /* Time Slot Map [5-22]                   */
-        VINT8       tscm[256];  /* Subchannel Map [5-24]                  */
-        VINT32      tcct[32];   /* Channel Configuration [5-26]           */
-        VINT8       rtsm[128];  /* Time Slot Map [5-22]                   */
-        VINT8       rscm[256];  /* Subchannel Map [5-24]                  */
-        VINT32      rcct[32];   /* Channel Configuration [5-26]           */
-        VINT32      glcd;       /* Global Configuration Descriptor [5-10] */
-        VINT32      iqp;        /* Interrupt Queue Pointer [5-36]         */
-        VINT32      iql;        /* Interrupt Queue Length [5-36]          */
-        VINT32      grcd;       /* Group Configuration Descriptor [5-16]  */
-        VINT32      mpd;        /* Memory Protection Descriptor [5-18]    */
-        VINT32      mld;        /* Message Length Descriptor [5-20]       */
-        VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
-        VINT32      rbist;      /* Receive BIST status [5-4]              */
-        VINT32      tbist;      /* Receive BIST status [5-4]              */
+	VINT32      gbp;        /* Group Base Pointer                     */
+	VINT32      dacbp;      /* Dual Address Cycle Base Pointer        */
+	VINT32      srd;        /* Service Request Descriptor             */
+	VINT32      isd;        /* Interrupt Service Descriptor           */
+	/*
+	 * adjust __thp due to above 4 registers, which are not contained
+	 * within musycc_groupr[]. All __XXX[] are just place holders,
+	 * anyhow.
+	 */
+	VINT32      __thp[32 - 4];      /* Transmit Head Pointer [5-29]           */
+	VINT32      __tmp[32];  /* Transmit Message Pointer [5-30]        */
+	VINT32      __rhp[32];  /* Receive Head Pointer [5-29]            */
+	VINT32      __rmp[32];  /* Receive Message Pointer [5-30]         */
+	VINT8       ttsm[128];  /* Time Slot Map [5-22]                   */
+	VINT8       tscm[256];  /* Subchannel Map [5-24]                  */
+	VINT32      tcct[32];   /* Channel Configuration [5-26]           */
+	VINT8       rtsm[128];  /* Time Slot Map [5-22]                   */
+	VINT8       rscm[256];  /* Subchannel Map [5-24]                  */
+	VINT32      rcct[32];   /* Channel Configuration [5-26]           */
+	VINT32      glcd;       /* Global Configuration Descriptor [5-10] */
+	VINT32      iqp;        /* Interrupt Queue Pointer [5-36]         */
+	VINT32      iql;        /* Interrupt Queue Length [5-36]          */
+	VINT32      grcd;       /* Group Configuration Descriptor [5-16]  */
+	VINT32      mpd;        /* Memory Protection Descriptor [5-18]    */
+	VINT32      mld;        /* Message Length Descriptor [5-20]       */
+	VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
+	VINT32      rbist;      /* Receive BIST status [5-4]              */
+	VINT32      tbist;      /* Receive BIST status [5-4]              */
     };
 
 /* Global Config Descriptor bit macros */
@@ -108,18 +108,18 @@
 #define MUSYCC_GCD_INTA_DISABLE 0x00000008      /* PCI INTA disable */
 #define MUSYCC_GCD_INTB_DISABLE 0x00000004      /* PCI INTB disable */
 #define MUSYCC_GCD_BLAPSE       12      /* Position index for BLAPSE bit
-                                         * field */
+					 * field */
 #define MUSYCC_GCD_ALAPSE       8       /* Position index for ALAPSE bit
-                                         * field */
+					 * field */
 #define MUSYCC_GCD_ELAPSE       4       /* Position index for ELAPSE bit
-                                         * field */
+					 * field */
 #define MUSYCC_GCD_PORTMAP_3    3       /* Reserved */
 #define MUSYCC_GCD_PORTMAP_2    2       /* Port 0=>Grp 0,1,2,3; Port 1=>Grp
-                                         * 4,5,6,7 */
+					 * 4,5,6,7 */
 #define MUSYCC_GCD_PORTMAP_1    1       /* Port 0=>Grp 0,1; Port 1=>Grp 2,3,
-                                         * etc... */
+					 * etc... */
 #define MUSYCC_GCD_PORTMAP_0    0       /* Port 0=>Grp 0; Port 1=>Grp 2,
-                                         * etc... */
+					 * etc... */
 
 /* and board specific assignments... */
 #ifdef SBE_WAN256T3_ENABLE
@@ -137,57 +137,57 @@
 #endif
 
 #define GCD_MAGIC   (((BLAPSE_VAL)<<(MUSYCC_GCD_BLAPSE)) | \
-                     ((ALAPSE_VAL)<<(MUSYCC_GCD_ALAPSE)) | \
-                     ((ELAPSE_VAL)<<(MUSYCC_GCD_ELAPSE)) | \
-                     (MUSYCC_GCD_ECLK_ENABLE) | PORTMAP_VAL)
+		     ((ALAPSE_VAL)<<(MUSYCC_GCD_ALAPSE)) | \
+		     ((ELAPSE_VAL)<<(MUSYCC_GCD_ELAPSE)) | \
+		     (MUSYCC_GCD_ECLK_ENABLE) | PORTMAP_VAL)
 
 /* Group Config Descriptor bit macros */
 #define MUSYCC_GRCD_RX_ENABLE       0x00000001  /* Enable receive processing */
 #define MUSYCC_GRCD_TX_ENABLE       0x00000002  /* Enable transmit processing */
 #define MUSYCC_GRCD_SUBCHAN_DISABLE 0x00000004  /* Master disable for
-                                                 * subchanneling */
+						 * subchanneling */
 #define MUSYCC_GRCD_OOFMP_DISABLE   0x00000008  /* Out of Frame message
-                                                 * processing disabled all
-                                                 * channels */
+						 * processing disabled all
+						 * channels */
 #define MUSYCC_GRCD_OOFIRQ_DISABLE  0x00000010  /* Out of Frame/In Frame irqs
-                                                 * disabled */
+						 * disabled */
 #define MUSYCC_GRCD_COFAIRQ_DISABLE 0x00000020  /* Change of Frame Alignment
-                                                 * irq disabled */
+						 * irq disabled */
 #define MUSYCC_GRCD_INHRBSD         0x00000100  /* Receive Buffer Status
-                                                 * overwrite disabled */
+						 * overwrite disabled */
 #define MUSYCC_GRCD_INHTBSD         0x00000200  /* Transmit Buffer Status
-                                                 * overwrite disabled */
+						 * overwrite disabled */
 #define MUSYCC_GRCD_SF_ALIGN        0x00008000  /* External frame sync */
 #define MUSYCC_GRCD_MC_ENABLE       0x00000040  /* Message configuration bits
-                                                 * copy enable. Conexant sez
-                                                 * turn this on */
+						 * copy enable. Conexant sez
+						 * turn this on */
 #define MUSYCC_GRCD_POLLTH_16       0x00000001  /* Poll every 16th frame */
 #define MUSYCC_GRCD_POLLTH_32       0x00000002  /* Poll every 32nd frame */
 #define MUSYCC_GRCD_POLLTH_64       0x00000003  /* Poll every 64th frame */
 #define MUSYCC_GRCD_POLLTH_SHIFT    10  /* Position index for poll throttle
-                                         * bit field */
+					 * bit field */
 #define MUSYCC_GRCD_SUERM_THRESH_SHIFT 16       /* Position index for SUERM
-                                                 * count threshold */
+						 * count threshold */
 
 /* Port Config Descriptor bit macros */
 #define MUSYCC_PCD_E1X2_MODE       2    /* Port mode in bits 0-2. T1 and E1 */
 #define MUSYCC_PCD_E1X4_MODE       3    /* are defined in cn847x.h */
 #define MUSYCC_PCD_NX64_MODE       4
 #define MUSYCC_PCD_TXDATA_RISING   0x00000010   /* Sample Tx data on TCLK
-                                                 * rising edge */
+						 * rising edge */
 #define MUSYCC_PCD_TXSYNC_RISING   0x00000020   /* Sample Tx frame sync on
-                                                 * TCLK rising edge */
+						 * TCLK rising edge */
 #define MUSYCC_PCD_RXDATA_RISING   0x00000040   /* Sample Rx data on RCLK
-                                                 * rising edge */
+						 * rising edge */
 #define MUSYCC_PCD_RXSYNC_RISING   0x00000080   /* Sample Rx frame sync on
-                                                 * RCLK rising edge */
+						 * RCLK rising edge */
 #define MUSYCC_PCD_ROOF_RISING     0x00000100   /* Sample Rx Out Of Frame
-                                                 * signal on RCLK rising edge */
+						 * signal on RCLK rising edge */
 #define MUSYCC_PCD_TX_DRIVEN       0x00000200   /* No mapped timeslots causes
-                                                 * logic 1 on output, else
-                                                 * tristate */
+						 * logic 1 on output, else
+						 * tristate */
 #define MUSYCC_PCD_PORTMODE_MASK   0xfffffff8   /* For changing the port mode
-                                                 * between E1 and T1 */
+						 * between E1 and T1 */
 
 /* Time Slot Descriptor bit macros */
 #define MUSYCC_TSD_MODE_64KBPS              4
@@ -202,17 +202,17 @@
 #define MUSYCC_CCD_BUFIRQ_DISABLE  0x00000002   /* BUFF and ONR irqs disabled */
 #define MUSYCC_CCD_EOMIRQ_DISABLE  0x00000004   /* EOM irq disabled */
 #define MUSYCC_CCD_MSGIRQ_DISABLE  0x00000008   /* LNG, FCS, ALIGN, and ABT
-                                                 * irqs disabled */
+						 * irqs disabled */
 #define MUSYCC_CCD_IDLEIRQ_DISABLE 0x00000010   /* CHABT, CHIC, and SHT irqs
-                                                 * disabled */
+						 * disabled */
 #define MUSYCC_CCD_FILTIRQ_DISABLE 0x00000020   /* SFILT irq disabled */
 #define MUSYCC_CCD_SDECIRQ_DISABLE 0x00000040   /* SDEC irq disabled */
 #define MUSYCC_CCD_SINCIRQ_DISABLE 0x00000080   /* SINC irq disabled */
 #define MUSYCC_CCD_SUERIRQ_DISABLE 0x00000100   /* SUERR irq disabled */
 #define MUSYCC_CCD_FCS_XFER        0x00000200   /* Propagate FCS along with
-                                                 * received data */
+						 * received data */
 #define MUSYCC_CCD_PROTO_SHIFT     12   /* Position index for protocol bit
-                                         * field */
+					 * field */
 #define MUSYCC_CCD_TRANS           0    /* Protocol mode in bits 12-14 */
 #define MUSYCC_CCD_SS7             1
 #define MUSYCC_CCD_HDLC_FCS16      2
@@ -220,11 +220,11 @@
 #define MUSYCC_CCD_EOPIRQ_DISABLE  0x00008000   /* EOP irq disabled */
 #define MUSYCC_CCD_INVERT_DATA     0x00800000   /* Invert data */
 #define MUSYCC_CCD_MAX_LENGTH      10   /* Position index for max length bit
-                                         * field */
+					 * field */
 #define MUSYCC_CCD_BUFFER_LENGTH   16   /* Position index for internal data
-                                         * buffer length */
+					 * buffer length */
 #define MUSYCC_CCD_BUFFER_LOC      24   /* Position index for internal data
-                                         * buffer starting location */
+					 * buffer starting location */
 
 /****************************************************************************
  * Interrupt Descriptor Information */
@@ -266,7 +266,7 @@
 #define INTRPT_GRP_S           29
 #define INTRPT_GRP_MSB_S       12
 #define INTRPT_GRP(x)          (((x & INTRPT_GRP_M) >> INTRPT_GRP_S) | \
-                               ((x & INTRPT_GRP_MSB_M) >> INTRPT_GRP_MSB_S))
+			       ((x & INTRPT_GRP_MSB_M) >> INTRPT_GRP_MSB_S))
 
 #define INTRPT_CH_M            0x1F000000
 #define INTRPT_CH_S            24
@@ -295,82 +295,82 @@
 
 /* Buffer Descriptor bit macros */
 #define OWNER_BIT       0x80000000      /* Set for MUSYCC owner on xmit, host
-                                         * owner on receive */
+					 * owner on receive */
 #define HOST_TX_OWNED   0x00000000      /* Host owns descriptor */
 #define MUSYCC_TX_OWNED 0x80000000      /* MUSYCC owns descriptor */
 #define HOST_RX_OWNED   0x80000000      /* Host owns descriptor */
 #define MUSYCC_RX_OWNED 0x00000000      /* MUSYCC owns descriptor */
 
 #define POLL_DISABLED   0x40000000      /* MUSYCC not allowed to poll buffer
-                                         * for ownership */
+					 * for ownership */
 #define EOMIRQ_ENABLE   0x20000000      /* This buffer contains the end of
-                                         * the message */
+					 * the message */
 #define EOBIRQ_ENABLE   0x10000000      /* EOB irq enabled */
 #define PADFILL_ENABLE  0x01000000      /* Enable padfill */
 #define REPEAT_BIT      0x00008000      /* Bit on for FISU descriptor */
 #define LENGTH_MASK         0X3fff      /* This part of status descriptor is
-                                         * length */
+					 * length */
 #define IDLE_CODE               25      /* Position index for idle code (2
-                                         * bits) */
+					 * bits) */
 #define EXTRA_FLAGS             16      /* Position index for minimum flags
-                                         * between messages (8 bits) */
+					 * between messages (8 bits) */
 #define IDLE_CODE_MASK        0x03      /* Gets rid of garbage before the
-                                         * pattern is OR'd in */
+					 * pattern is OR'd in */
 #define EXTRA_FLAGS_MASK      0xff      /* Gets rid of garbage before the
-                                         * pattern is OR'd in */
+					 * pattern is OR'd in */
 #define PCI_PERMUTED_OWNER_BIT  0x00000080      /* For flipping the bit on
-                                                 * the polled mode descriptor */
+						 * the polled mode descriptor */
 
 /* Service Request Descriptor bit macros */
 #define SREQ  8                 /* Position index for service request bit
-                                 * field */
+				 * field */
 #define SR_NOOP                 (0<<(SREQ))     /* No Operation. Generates SACK */
 #define SR_CHIP_RESET           (1<<(SREQ))     /* Soft chip reset */
 #define SR_GROUP_RESET          (2<<(SREQ))     /* Group reset */
 #define SR_GLOBAL_INIT          (4<<(SREQ))     /* Global init: read global
-                                                 * config deswc and interrupt
-                                                 * queue desc */
+						 * config deswc and interrupt
+						 * queue desc */
 #define SR_GROUP_INIT           (5<<(SREQ))     /* Group init: read Timeslot
-                                                 * and Subchannel maps,
-                                                 * Channel Config, */
+						 * and Subchannel maps,
+						 * Channel Config, */
     /*
      * Group Config, Memory Protect, Message Length, and Port Config
      * Descriptors
      */
 #define SR_CHANNEL_ACTIVATE     (8<<(SREQ))     /* Init channel, read Head
-                                                 * Pointer, process first
-                                                 * Message Descriptor */
+						 * Pointer, process first
+						 * Message Descriptor */
 #define SR_GCHANNEL_MASK        0x001F          /* channel portion (gchan) */
 #define SR_CHANNEL_DEACTIVATE   (9<<(SREQ))     /* Stop channel processing */
 #define SR_JUMP                 (10<<(SREQ))    /* a: Process new Message
-                                                 * List */
+						 * List */
 #define SR_CHANNEL_CONFIG       (11<<(SREQ))    /* b: Read channel
-                                                 * Configuration Descriptor */
+						 * Configuration Descriptor */
 #define SR_GLOBAL_CONFIG        (16<<(SREQ))    /* 10: Read Global
-                                                 * Configuration Descriptor */
+						 * Configuration Descriptor */
 #define SR_INTERRUPT_Q          (17<<(SREQ))    /* 11: Read Interrupt Queue
-                                                 * Descriptor */
+						 * Descriptor */
 #define SR_GROUP_CONFIG         (18<<(SREQ))    /* 12: Read Group
-                                                 * Configuration Descriptor */
+						 * Configuration Descriptor */
 #define SR_MEMORY_PROTECT       (19<<(SREQ))    /* 13: Read Memory Protection
-                                                 * Descriptor */
+						 * Descriptor */
 #define SR_MESSAGE_LENGTH       (20<<(SREQ))    /* 14: Read Message Length
-                                                 * Descriptor */
+						 * Descriptor */
 #define SR_PORT_CONFIG          (21<<(SREQ))    /* 15: Read Port
-                                                 * Configuration Descriptor */
+						 * Configuration Descriptor */
 #define SR_TIMESLOT_MAP         (24<<(SREQ))    /* 18: Read Timeslot Map */
 #define SR_SUBCHANNEL_MAP       (25<<(SREQ))    /* 19: Read Subchannel Map */
 #define SR_CHAN_CONFIG_TABLE    (26<<(SREQ))    /* 20: Read Channel
-                                                 * Configuration Table for
-                                                 * the group */
+						 * Configuration Table for
+						 * the group */
 #define SR_TX_DIRECTION         0x00000020      /* Transmit direction bit.
-                                                 * Bit off indicates receive
-                                                 * direction */
+						 * Bit off indicates receive
+						 * direction */
 #define SR_RX_DIRECTION         0x00000000
 
 /* Interrupt Descriptor bit macros */
 #define GROUP10                     29  /* Position index for the 2 LS group
-                                         * bits */
+					 * bits */
 #define CHANNEL                     24  /* Position index for channel bits */
 #define INT_IQD_TX          0x80000000
 #define INT_IQD_GRP         0x60000000
@@ -384,7 +384,7 @@
 /* Interrupt Descriptor Events */
 #define EVE_EVENT               20      /* Position index for event bits */
 #define EVE_NONE                0       /* No event to report in this
-                                         * interrupt */
+					 * interrupt */
 #define EVE_SACK                1       /* Service Request acknowledge */
 #define EVE_EOB                 2       /* End of Buffer */
 #define EVE_EOM                 3       /* End of Message */
@@ -411,12 +411,12 @@
 #define ERR_PERR                15      /* PCI Parity Error */
 /* Other Stuff */
 #define TRANSMIT_DIRECTION  0x80000000  /* Transmit direction bit. Bit off
-                                         * indicates receive direction */
+					 * indicates receive direction */
 #define ILOST               0x00008000  /* Interrupt Lost */
 #define GROUPMSB            0x00004000  /* Group number MSB */
 #define SACK_IMAGE          0x00100000  /* Used in IRQ for semaphore test */
 #define INITIAL_STATUS      0x10000     /* IRQ status should be this after
-                                         * reset */
+					 * reset */
 
 /*  This must be defined on an entire channel group (Port) basis */
 #define SUERM_THRESHOLD     0x1f
-- 
1.7.10.4

