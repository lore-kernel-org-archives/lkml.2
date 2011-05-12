Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1ELNdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:33:13 -0400
Received: from relay3.sgi.com ([192.48.152.1]:32843 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756572Ab1ELNdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:33:11 -0400
Date: Thu, 12 May 2011 08:33:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Reformat uv_mmrs.h - no code changes
Message-ID: <20110512133308.GA17113@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No code changes.  Reformat file to eliminate errors caught
by checkpatch.pl

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_mmrs.h | 1147 ++++++++++++++++++--------------------
 1 file changed, 573 insertions(+), 574 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2011-05-11 08:58:11.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2011-05-12 08:22:12.408878288 -0500
@@ -74,11 +74,11 @@
 #define UVH_BAU_DATA_BROADCAST_ENABLE_MASK 0x0000000000000001UL
 
 union uvh_bau_data_broadcast_u {
-    unsigned long	v;
-    struct uvh_bau_data_broadcast_s {
-	unsigned long	enable :  1;  /* RW */
-	unsigned long	rsvd_1_63: 63;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_bau_data_broadcast_s {
+		unsigned long enable:1;	/* RW */
+		unsigned long rsvd_1_63:63;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -105,19 +105,19 @@ union uvh_bau_data_broadcast_u {
 #define UVH_BAU_DATA_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_bau_data_config_u {
-    unsigned long	v;
-    struct uvh_bau_data_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_bau_data_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -361,129 +361,129 @@ union uvh_bau_data_config_u {
 #define UV2H_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0400000000000000UL
 
 union uvh_event_occurred0_u {
-    unsigned long	v;
-    struct uv1h_event_occurred0_s {
-	unsigned long	lb_hcerr             :  1;  /* RW, W1C */
-	unsigned long	gr0_hcerr            :  1;  /* RW, W1C */
-	unsigned long	gr1_hcerr            :  1;  /* RW, W1C */
-	unsigned long	lh_hcerr             :  1;  /* RW, W1C */
-	unsigned long	rh_hcerr             :  1;  /* RW, W1C */
-	unsigned long	xn_hcerr             :  1;  /* RW, W1C */
-	unsigned long	si_hcerr             :  1;  /* RW, W1C */
-	unsigned long	lb_aoerr0            :  1;  /* RW, W1C */
-	unsigned long	gr0_aoerr0           :  1;  /* RW, W1C */
-	unsigned long	gr1_aoerr0           :  1;  /* RW, W1C */
-	unsigned long	lh_aoerr0            :  1;  /* RW, W1C */
-	unsigned long	rh_aoerr0            :  1;  /* RW, W1C */
-	unsigned long	xn_aoerr0            :  1;  /* RW, W1C */
-	unsigned long	si_aoerr0            :  1;  /* RW, W1C */
-	unsigned long	lb_aoerr1            :  1;  /* RW, W1C */
-	unsigned long	gr0_aoerr1           :  1;  /* RW, W1C */
-	unsigned long	gr1_aoerr1           :  1;  /* RW, W1C */
-	unsigned long	lh_aoerr1            :  1;  /* RW, W1C */
-	unsigned long	rh_aoerr1            :  1;  /* RW, W1C */
-	unsigned long	xn_aoerr1            :  1;  /* RW, W1C */
-	unsigned long	si_aoerr1            :  1;  /* RW, W1C */
-	unsigned long	rh_vpi_int           :  1;  /* RW, W1C */
-	unsigned long	system_shutdown_int  :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_0         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_1         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_2         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_3         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_4         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_5         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_6         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_7         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_8         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_9         :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_10        :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_11        :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_12        :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_13        :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_14        :  1;  /* RW, W1C */
-	unsigned long	lb_irq_int_15        :  1;  /* RW, W1C */
-	unsigned long	l1_nmi_int           :  1;  /* RW, W1C */
-	unsigned long	stop_clock           :  1;  /* RW, W1C */
-	unsigned long	asic_to_l1           :  1;  /* RW, W1C */
-	unsigned long	l1_to_asic           :  1;  /* RW, W1C */
-	unsigned long	ltc_int              :  1;  /* RW, W1C */
-	unsigned long	la_seq_trigger       :  1;  /* RW, W1C */
-	unsigned long	ipi_int              :  1;  /* RW, W1C */
-	unsigned long	extio_int0           :  1;  /* RW, W1C */
-	unsigned long	extio_int1           :  1;  /* RW, W1C */
-	unsigned long	extio_int2           :  1;  /* RW, W1C */
-	unsigned long	extio_int3           :  1;  /* RW, W1C */
-	unsigned long	profile_int          :  1;  /* RW, W1C */
-	unsigned long	rtc0                 :  1;  /* RW, W1C */
-	unsigned long	rtc1                 :  1;  /* RW, W1C */
-	unsigned long	rtc2                 :  1;  /* RW, W1C */
-	unsigned long	rtc3                 :  1;  /* RW, W1C */
-	unsigned long	bau_data             :  1;  /* RW, W1C */
-	unsigned long	power_management_req :  1;  /* RW, W1C */
-	unsigned long	rsvd_57_63           :  7;  /*    */
-    } s1;
-    struct uv2h_event_occurred0_s {
-	unsigned long	lb_hcerr            :  1;  /* RW */
-	unsigned long	qp_hcerr            :  1;  /* RW */
-	unsigned long	rh_hcerr            :  1;  /* RW */
-	unsigned long	lh0_hcerr           :  1;  /* RW */
-	unsigned long	lh1_hcerr           :  1;  /* RW */
-	unsigned long	gr0_hcerr           :  1;  /* RW */
-	unsigned long	gr1_hcerr           :  1;  /* RW */
-	unsigned long	ni0_hcerr           :  1;  /* RW */
-	unsigned long	ni1_hcerr           :  1;  /* RW */
-	unsigned long	lb_aoerr0           :  1;  /* RW */
-	unsigned long	qp_aoerr0           :  1;  /* RW */
-	unsigned long	rh_aoerr0           :  1;  /* RW */
-	unsigned long	lh0_aoerr0          :  1;  /* RW */
-	unsigned long	lh1_aoerr0          :  1;  /* RW */
-	unsigned long	gr0_aoerr0          :  1;  /* RW */
-	unsigned long	gr1_aoerr0          :  1;  /* RW */
-	unsigned long	xb_aoerr0           :  1;  /* RW */
-	unsigned long	rt_aoerr0           :  1;  /* RW */
-	unsigned long	ni0_aoerr0          :  1;  /* RW */
-	unsigned long	ni1_aoerr0          :  1;  /* RW */
-	unsigned long	lb_aoerr1           :  1;  /* RW */
-	unsigned long	qp_aoerr1           :  1;  /* RW */
-	unsigned long	rh_aoerr1           :  1;  /* RW */
-	unsigned long	lh0_aoerr1          :  1;  /* RW */
-	unsigned long	lh1_aoerr1          :  1;  /* RW */
-	unsigned long	gr0_aoerr1          :  1;  /* RW */
-	unsigned long	gr1_aoerr1          :  1;  /* RW */
-	unsigned long	xb_aoerr1           :  1;  /* RW */
-	unsigned long	rt_aoerr1           :  1;  /* RW */
-	unsigned long	ni0_aoerr1          :  1;  /* RW */
-	unsigned long	ni1_aoerr1          :  1;  /* RW */
-	unsigned long	system_shutdown_int :  1;  /* RW */
-	unsigned long	lb_irq_int_0        :  1;  /* RW */
-	unsigned long	lb_irq_int_1        :  1;  /* RW */
-	unsigned long	lb_irq_int_2        :  1;  /* RW */
-	unsigned long	lb_irq_int_3        :  1;  /* RW */
-	unsigned long	lb_irq_int_4        :  1;  /* RW */
-	unsigned long	lb_irq_int_5        :  1;  /* RW */
-	unsigned long	lb_irq_int_6        :  1;  /* RW */
-	unsigned long	lb_irq_int_7        :  1;  /* RW */
-	unsigned long	lb_irq_int_8        :  1;  /* RW */
-	unsigned long	lb_irq_int_9        :  1;  /* RW */
-	unsigned long	lb_irq_int_10       :  1;  /* RW */
-	unsigned long	lb_irq_int_11       :  1;  /* RW */
-	unsigned long	lb_irq_int_12       :  1;  /* RW */
-	unsigned long	lb_irq_int_13       :  1;  /* RW */
-	unsigned long	lb_irq_int_14       :  1;  /* RW */
-	unsigned long	lb_irq_int_15       :  1;  /* RW */
-	unsigned long	l1_nmi_int          :  1;  /* RW */
-	unsigned long	stop_clock          :  1;  /* RW */
-	unsigned long	asic_to_l1          :  1;  /* RW */
-	unsigned long	l1_to_asic          :  1;  /* RW */
-	unsigned long	la_seq_trigger      :  1;  /* RW */
-	unsigned long	ipi_int             :  1;  /* RW */
-	unsigned long	extio_int0          :  1;  /* RW */
-	unsigned long	extio_int1          :  1;  /* RW */
-	unsigned long	extio_int2          :  1;  /* RW */
-	unsigned long	extio_int3          :  1;  /* RW */
-	unsigned long	profile_int         :  1;  /* RW */
-	unsigned long	rsvd_59_63          :  5;  /*    */
-    } s2;
+	unsigned long v;
+	struct uv1h_event_occurred0_s {
+		unsigned long lb_hcerr:1;	/* RW, W1C */
+		unsigned long gr0_hcerr:1;	/* RW, W1C */
+		unsigned long gr1_hcerr:1;	/* RW, W1C */
+		unsigned long lh_hcerr:1;	/* RW, W1C */
+		unsigned long rh_hcerr:1;	/* RW, W1C */
+		unsigned long xn_hcerr:1;	/* RW, W1C */
+		unsigned long si_hcerr:1;	/* RW, W1C */
+		unsigned long lb_aoerr0:1;	/* RW, W1C */
+		unsigned long gr0_aoerr0:1;	/* RW, W1C */
+		unsigned long gr1_aoerr0:1;	/* RW, W1C */
+		unsigned long lh_aoerr0:1;	/* RW, W1C */
+		unsigned long rh_aoerr0:1;	/* RW, W1C */
+		unsigned long xn_aoerr0:1;	/* RW, W1C */
+		unsigned long si_aoerr0:1;	/* RW, W1C */
+		unsigned long lb_aoerr1:1;	/* RW, W1C */
+		unsigned long gr0_aoerr1:1;	/* RW, W1C */
+		unsigned long gr1_aoerr1:1;	/* RW, W1C */
+		unsigned long lh_aoerr1:1;	/* RW, W1C */
+		unsigned long rh_aoerr1:1;	/* RW, W1C */
+		unsigned long xn_aoerr1:1;	/* RW, W1C */
+		unsigned long si_aoerr1:1;	/* RW, W1C */
+		unsigned long rh_vpi_int:1;	/* RW, W1C */
+		unsigned long system_shutdown_int:1;	/* RW, W1C */
+		unsigned long lb_irq_int_0:1;	/* RW, W1C */
+		unsigned long lb_irq_int_1:1;	/* RW, W1C */
+		unsigned long lb_irq_int_2:1;	/* RW, W1C */
+		unsigned long lb_irq_int_3:1;	/* RW, W1C */
+		unsigned long lb_irq_int_4:1;	/* RW, W1C */
+		unsigned long lb_irq_int_5:1;	/* RW, W1C */
+		unsigned long lb_irq_int_6:1;	/* RW, W1C */
+		unsigned long lb_irq_int_7:1;	/* RW, W1C */
+		unsigned long lb_irq_int_8:1;	/* RW, W1C */
+		unsigned long lb_irq_int_9:1;	/* RW, W1C */
+		unsigned long lb_irq_int_10:1;	/* RW, W1C */
+		unsigned long lb_irq_int_11:1;	/* RW, W1C */
+		unsigned long lb_irq_int_12:1;	/* RW, W1C */
+		unsigned long lb_irq_int_13:1;	/* RW, W1C */
+		unsigned long lb_irq_int_14:1;	/* RW, W1C */
+		unsigned long lb_irq_int_15:1;	/* RW, W1C */
+		unsigned long l1_nmi_int:1;	/* RW, W1C */
+		unsigned long stop_clock:1;	/* RW, W1C */
+		unsigned long asic_to_l1:1;	/* RW, W1C */
+		unsigned long l1_to_asic:1;	/* RW, W1C */
+		unsigned long ltc_int:1;	/* RW, W1C */
+		unsigned long la_seq_trigger:1;	/* RW, W1C */
+		unsigned long ipi_int:1;	/* RW, W1C */
+		unsigned long extio_int0:1;	/* RW, W1C */
+		unsigned long extio_int1:1;	/* RW, W1C */
+		unsigned long extio_int2:1;	/* RW, W1C */
+		unsigned long extio_int3:1;	/* RW, W1C */
+		unsigned long profile_int:1;	/* RW, W1C */
+		unsigned long rtc0:1;	/* RW, W1C */
+		unsigned long rtc1:1;	/* RW, W1C */
+		unsigned long rtc2:1;	/* RW, W1C */
+		unsigned long rtc3:1;	/* RW, W1C */
+		unsigned long bau_data:1;	/* RW, W1C */
+		unsigned long power_management_req:1;	/* RW, W1C */
+		unsigned long rsvd_57_63:7;	/*    */
+	} s1;
+	struct uv2h_event_occurred0_s {
+		unsigned long lb_hcerr:1;	/* RW */
+		unsigned long qp_hcerr:1;	/* RW */
+		unsigned long rh_hcerr:1;	/* RW */
+		unsigned long lh0_hcerr:1;	/* RW */
+		unsigned long lh1_hcerr:1;	/* RW */
+		unsigned long gr0_hcerr:1;	/* RW */
+		unsigned long gr1_hcerr:1;	/* RW */
+		unsigned long ni0_hcerr:1;	/* RW */
+		unsigned long ni1_hcerr:1;	/* RW */
+		unsigned long lb_aoerr0:1;	/* RW */
+		unsigned long qp_aoerr0:1;	/* RW */
+		unsigned long rh_aoerr0:1;	/* RW */
+		unsigned long lh0_aoerr0:1;	/* RW */
+		unsigned long lh1_aoerr0:1;	/* RW */
+		unsigned long gr0_aoerr0:1;	/* RW */
+		unsigned long gr1_aoerr0:1;	/* RW */
+		unsigned long xb_aoerr0:1;	/* RW */
+		unsigned long rt_aoerr0:1;	/* RW */
+		unsigned long ni0_aoerr0:1;	/* RW */
+		unsigned long ni1_aoerr0:1;	/* RW */
+		unsigned long lb_aoerr1:1;	/* RW */
+		unsigned long qp_aoerr1:1;	/* RW */
+		unsigned long rh_aoerr1:1;	/* RW */
+		unsigned long lh0_aoerr1:1;	/* RW */
+		unsigned long lh1_aoerr1:1;	/* RW */
+		unsigned long gr0_aoerr1:1;	/* RW */
+		unsigned long gr1_aoerr1:1;	/* RW */
+		unsigned long xb_aoerr1:1;	/* RW */
+		unsigned long rt_aoerr1:1;	/* RW */
+		unsigned long ni0_aoerr1:1;	/* RW */
+		unsigned long ni1_aoerr1:1;	/* RW */
+		unsigned long system_shutdown_int:1;	/* RW */
+		unsigned long lb_irq_int_0:1;	/* RW */
+		unsigned long lb_irq_int_1:1;	/* RW */
+		unsigned long lb_irq_int_2:1;	/* RW */
+		unsigned long lb_irq_int_3:1;	/* RW */
+		unsigned long lb_irq_int_4:1;	/* RW */
+		unsigned long lb_irq_int_5:1;	/* RW */
+		unsigned long lb_irq_int_6:1;	/* RW */
+		unsigned long lb_irq_int_7:1;	/* RW */
+		unsigned long lb_irq_int_8:1;	/* RW */
+		unsigned long lb_irq_int_9:1;	/* RW */
+		unsigned long lb_irq_int_10:1;	/* RW */
+		unsigned long lb_irq_int_11:1;	/* RW */
+		unsigned long lb_irq_int_12:1;	/* RW */
+		unsigned long lb_irq_int_13:1;	/* RW */
+		unsigned long lb_irq_int_14:1;	/* RW */
+		unsigned long lb_irq_int_15:1;	/* RW */
+		unsigned long l1_nmi_int:1;	/* RW */
+		unsigned long stop_clock:1;	/* RW */
+		unsigned long asic_to_l1:1;	/* RW */
+		unsigned long l1_to_asic:1;	/* RW */
+		unsigned long la_seq_trigger:1;	/* RW */
+		unsigned long ipi_int:1;	/* RW */
+		unsigned long extio_int0:1;	/* RW */
+		unsigned long extio_int1:1;	/* RW */
+		unsigned long extio_int2:1;	/* RW */
+		unsigned long extio_int3:1;	/* RW */
+		unsigned long profile_int:1;	/* RW */
+		unsigned long rsvd_59_63:5;	/*    */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -515,19 +515,19 @@ union uvh_event_occurred0_u {
 #define UVH_GR0_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_gr0_tlb_int0_config_u {
-    unsigned long	v;
-    struct uvh_gr0_tlb_int0_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_gr0_tlb_int0_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -553,19 +553,19 @@ union uvh_gr0_tlb_int0_config_u {
 #define UVH_GR0_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_gr0_tlb_int1_config_u {
-    unsigned long	v;
-    struct uvh_gr0_tlb_int1_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_gr0_tlb_int1_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -591,19 +591,19 @@ union uvh_gr0_tlb_int1_config_u {
 #define UVH_GR1_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_gr1_tlb_int0_config_u {
-    unsigned long	v;
-    struct uvh_gr1_tlb_int0_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_gr1_tlb_int0_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -629,19 +629,19 @@ union uvh_gr1_tlb_int0_config_u {
 #define UVH_GR1_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_gr1_tlb_int1_config_u {
-    unsigned long	v;
-    struct uvh_gr1_tlb_int1_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_gr1_tlb_int1_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -653,11 +653,11 @@ union uvh_gr1_tlb_int1_config_u {
 #define UVH_INT_CMPB_REAL_TIME_CMPB_MASK 0x00ffffffffffffffUL
 
 union uvh_int_cmpb_u {
-    unsigned long	v;
-    struct uvh_int_cmpb_s {
-	unsigned long	real_time_cmpb : 56;  /* RW */
-	unsigned long	rsvd_56_63     :  8;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_int_cmpb_s {
+		unsigned long real_time_cmpb:56;	/* RW */
+		unsigned long rsvd_56_63:8;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -677,11 +677,11 @@ union uvh_int_cmpb_u {
 			UV2H_INT_CMPC_REAL_TIME_CMPC_MASK)
 
 union uvh_int_cmpc_u {
-    unsigned long	v;
-    struct uvh_int_cmpc_s {
-	unsigned long	real_time_cmpc : 56;  /* RW */
-	unsigned long	rsvd_56_63     :  8;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_int_cmpc_s {
+		unsigned long real_time_cmpc:56;	/* RW */
+		unsigned long rsvd_56_63:8;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -701,11 +701,11 @@ union uvh_int_cmpc_u {
 			UV2H_INT_CMPD_REAL_TIME_CMPD_MASK)
 
 union uvh_int_cmpd_u {
-    unsigned long	v;
-    struct uvh_int_cmpd_s {
-	unsigned long	real_time_cmpd : 56;  /* RW */
-	unsigned long	rsvd_56_63     :  8;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_int_cmpd_s {
+		unsigned long real_time_cmpd:56;	/* RW */
+		unsigned long rsvd_56_63:8;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -726,16 +726,16 @@ union uvh_int_cmpd_u {
 #define UVH_IPI_INT_SEND_MASK 0x8000000000000000UL
 
 union uvh_ipi_int_u {
-    unsigned long	v;
-    struct uvh_ipi_int_s {
-	unsigned long	vector_       :  8;  /* RW */
-	unsigned long	delivery_mode :  3;  /* RW */
-	unsigned long	destmode      :  1;  /* RW */
-	unsigned long	rsvd_12_15    :  4;  /*    */
-	unsigned long	apic_id       : 32;  /* RW */
-	unsigned long	rsvd_48_62    : 15;  /*    */
-	unsigned long	send          :  1;  /* WP */
-    } s;
+	unsigned long v;
+	struct uvh_ipi_int_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long delivery_mode:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long rsvd_12_15:4;	/*    */
+		unsigned long apic_id:32;	/* RW */
+		unsigned long rsvd_48_62:15;	/*    */
+		unsigned long send:1;	/* WP */
+	} s;
 };
 
 /* ========================================================================= */
@@ -750,14 +750,14 @@ union uvh_ipi_int_u {
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_NODE_ID_MASK 0x7ffe000000000000UL
 
 union uvh_lb_bau_intd_payload_queue_first_u {
-    unsigned long	v;
-    struct uvh_lb_bau_intd_payload_queue_first_s {
-	unsigned long	rsvd_0_3:  4;  /*    */
-	unsigned long	address : 39;  /* RW */
-	unsigned long	rsvd_43_48:  6;  /*    */
-	unsigned long	node_id : 14;  /* RW */
-	unsigned long	rsvd_63 :  1;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_intd_payload_queue_first_s {
+		unsigned long rsvd_0_3:4;	/*    */
+		unsigned long address:39;	/* RW */
+		unsigned long rsvd_43_48:6;	/*    */
+		unsigned long node_id:14;	/* RW */
+		unsigned long rsvd_63:1;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -770,12 +770,12 @@ union uvh_lb_bau_intd_payload_queue_firs
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_MASK 0x000007fffffffff0UL
 
 union uvh_lb_bau_intd_payload_queue_last_u {
-    unsigned long	v;
-    struct uvh_lb_bau_intd_payload_queue_last_s {
-	unsigned long	rsvd_0_3:  4;  /*    */
-	unsigned long	address : 39;  /* RW */
-	unsigned long	rsvd_43_63: 21;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_intd_payload_queue_last_s {
+		unsigned long rsvd_0_3:4;	/*    */
+		unsigned long address:39;	/* RW */
+		unsigned long rsvd_43_63:21;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -788,12 +788,12 @@ union uvh_lb_bau_intd_payload_queue_last
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_MASK 0x000007fffffffff0UL
 
 union uvh_lb_bau_intd_payload_queue_tail_u {
-    unsigned long	v;
-    struct uvh_lb_bau_intd_payload_queue_tail_s {
-	unsigned long	rsvd_0_3:  4;  /*    */
-	unsigned long	address : 39;  /* RW */
-	unsigned long	rsvd_43_63: 21;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_intd_payload_queue_tail_s {
+		unsigned long rsvd_0_3:4;	/*    */
+		unsigned long address:39;	/* RW */
+		unsigned long rsvd_43_63:21;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -836,26 +836,26 @@ union uvh_lb_bau_intd_payload_queue_tail
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_7_MASK 0x0000000000008000UL
 
 union uvh_lb_bau_intd_software_acknowledge_u {
-    unsigned long	v;
-    struct uvh_lb_bau_intd_software_acknowledge_s {
-	unsigned long	pending_0 :  1;  /* RW, W1C */
-	unsigned long	pending_1 :  1;  /* RW, W1C */
-	unsigned long	pending_2 :  1;  /* RW, W1C */
-	unsigned long	pending_3 :  1;  /* RW, W1C */
-	unsigned long	pending_4 :  1;  /* RW, W1C */
-	unsigned long	pending_5 :  1;  /* RW, W1C */
-	unsigned long	pending_6 :  1;  /* RW, W1C */
-	unsigned long	pending_7 :  1;  /* RW, W1C */
-	unsigned long	timeout_0 :  1;  /* RW, W1C */
-	unsigned long	timeout_1 :  1;  /* RW, W1C */
-	unsigned long	timeout_2 :  1;  /* RW, W1C */
-	unsigned long	timeout_3 :  1;  /* RW, W1C */
-	unsigned long	timeout_4 :  1;  /* RW, W1C */
-	unsigned long	timeout_5 :  1;  /* RW, W1C */
-	unsigned long	timeout_6 :  1;  /* RW, W1C */
-	unsigned long	timeout_7 :  1;  /* RW, W1C */
-	unsigned long	rsvd_16_63: 48;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_intd_software_acknowledge_s {
+		unsigned long pending_0:1;	/* RW, W1C */
+		unsigned long pending_1:1;	/* RW, W1C */
+		unsigned long pending_2:1;	/* RW, W1C */
+		unsigned long pending_3:1;	/* RW, W1C */
+		unsigned long pending_4:1;	/* RW, W1C */
+		unsigned long pending_5:1;	/* RW, W1C */
+		unsigned long pending_6:1;	/* RW, W1C */
+		unsigned long pending_7:1;	/* RW, W1C */
+		unsigned long timeout_0:1;	/* RW, W1C */
+		unsigned long timeout_1:1;	/* RW, W1C */
+		unsigned long timeout_2:1;	/* RW, W1C */
+		unsigned long timeout_3:1;	/* RW, W1C */
+		unsigned long timeout_4:1;	/* RW, W1C */
+		unsigned long timeout_5:1;	/* RW, W1C */
+		unsigned long timeout_6:1;	/* RW, W1C */
+		unsigned long timeout_7:1;	/* RW, W1C */
+		unsigned long rsvd_16_63:48;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -982,70 +982,70 @@ union uvh_lb_bau_intd_software_acknowled
 #define UV2H_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
 
 union uvh_lb_bau_misc_control_u {
-    unsigned long	v;
-    struct uvh_lb_bau_misc_control_s {
-	unsigned long	rejection_delay                    :  8;  /* RW */
-	unsigned long	apic_mode                          :  1;  /* RW */
-	unsigned long	force_broadcast                    :  1;  /* RW */
-	unsigned long	force_lock_nop                     :  1;  /* RW */
-	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
-	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
-	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
-	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
-	unsigned long	enable_dual_mapping_mode           :  1;  /* RW */
-	unsigned long	vga_io_port_decode_enable          :  1;  /* RW */
-	unsigned long	vga_io_port_16_bit_decode          :  1;  /* RW */
-	unsigned long	suppress_dest_registration         :  1;  /* RW */
-	unsigned long	programmed_initial_priority        :  3;  /* RW */
-	unsigned long	use_incoming_priority              :  1;  /* RW */
-	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
-	unsigned long	rsvd_29_63    : 35;
-    } s;
-    struct uv1h_lb_bau_misc_control_s {
-	unsigned long	rejection_delay                    :  8;  /* RW */
-	unsigned long	apic_mode                          :  1;  /* RW */
-	unsigned long	force_broadcast                    :  1;  /* RW */
-	unsigned long	force_lock_nop                     :  1;  /* RW */
-	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
-	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
-	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
-	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
-	unsigned long	enable_dual_mapping_mode           :  1;  /* RW */
-	unsigned long	vga_io_port_decode_enable          :  1;  /* RW */
-	unsigned long	vga_io_port_16_bit_decode          :  1;  /* RW */
-	unsigned long	suppress_dest_registration         :  1;  /* RW */
-	unsigned long	programmed_initial_priority        :  3;  /* RW */
-	unsigned long	use_incoming_priority              :  1;  /* RW */
-	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
-	unsigned long	rsvd_29_47                         : 19;  /*    */
-	unsigned long	fun                                : 16;  /* RW */
-    } s1;
-    struct uv2h_lb_bau_misc_control_s {
-	unsigned long	rejection_delay                      :  8;  /* RW */
-	unsigned long	apic_mode                            :  1;  /* RW */
-	unsigned long	force_broadcast                      :  1;  /* RW */
-	unsigned long	force_lock_nop                       :  1;  /* RW */
-	unsigned long	qpi_agent_presence_vector            :  3;  /* RW */
-	unsigned long	descriptor_fetch_mode                :  1;  /* RW */
-	unsigned long	enable_intd_soft_ack_mode            :  1;  /* RW */
-	unsigned long	intd_soft_ack_timeout_period         :  4;  /* RW */
-	unsigned long	enable_dual_mapping_mode             :  1;  /* RW */
-	unsigned long	vga_io_port_decode_enable            :  1;  /* RW */
-	unsigned long	vga_io_port_16_bit_decode            :  1;  /* RW */
-	unsigned long	suppress_dest_registration           :  1;  /* RW */
-	unsigned long	programmed_initial_priority          :  3;  /* RW */
-	unsigned long	use_incoming_priority                :  1;  /* RW */
-	unsigned long	enable_programmed_initial_priority   :  1;  /* RW */
-	unsigned long	enable_automatic_apic_mode_selection :  1;  /* RW */
-	unsigned long	apic_mode_status                     :  1;  /* RO */
-	unsigned long	suppress_interrupts_to_self          :  1;  /* RW */
-	unsigned long	enable_lock_based_system_flush       :  1;  /* RW */
-	unsigned long	enable_extended_sb_status            :  1;  /* RW */
-	unsigned long	suppress_int_prio_udt_to_self        :  1;  /* RW */
-	unsigned long	use_legacy_descriptor_formats        :  1;  /* RW */
-	unsigned long	rsvd_36_47                           : 12;  /*    */
-	unsigned long	fun                                  : 16;  /* RW */
-    } s2;
+	unsigned long v;
+	struct uvh_lb_bau_misc_control_s {
+		unsigned long rejection_delay:8;	/* RW */
+		unsigned long apic_mode:1;	/* RW */
+		unsigned long force_broadcast:1;	/* RW */
+		unsigned long force_lock_nop:1;	/* RW */
+		unsigned long qpi_agent_presence_vector:3;	/* RW */
+		unsigned long descriptor_fetch_mode:1;	/* RW */
+		unsigned long enable_intd_soft_ack_mode:1;	/* RW */
+		unsigned long intd_soft_ack_timeout_period:4;	/* RW */
+		unsigned long enable_dual_mapping_mode:1;	/* RW */
+		unsigned long vga_io_port_decode_enable:1;	/* RW */
+		unsigned long vga_io_port_16_bit_decode:1;	/* RW */
+		unsigned long suppress_dest_registration:1;	/* RW */
+		unsigned long programmed_initial_priority:3;	/* RW */
+		unsigned long use_incoming_priority:1;	/* RW */
+		unsigned long enable_programmed_initial_priority:1;	/* RW */
+		unsigned long rsvd_29_63:35;
+	} s;
+	struct uv1h_lb_bau_misc_control_s {
+		unsigned long rejection_delay:8;	/* RW */
+		unsigned long apic_mode:1;	/* RW */
+		unsigned long force_broadcast:1;	/* RW */
+		unsigned long force_lock_nop:1;	/* RW */
+		unsigned long qpi_agent_presence_vector:3;	/* RW */
+		unsigned long descriptor_fetch_mode:1;	/* RW */
+		unsigned long enable_intd_soft_ack_mode:1;	/* RW */
+		unsigned long intd_soft_ack_timeout_period:4;	/* RW */
+		unsigned long enable_dual_mapping_mode:1;	/* RW */
+		unsigned long vga_io_port_decode_enable:1;	/* RW */
+		unsigned long vga_io_port_16_bit_decode:1;	/* RW */
+		unsigned long suppress_dest_registration:1;	/* RW */
+		unsigned long programmed_initial_priority:3;	/* RW */
+		unsigned long use_incoming_priority:1;	/* RW */
+		unsigned long enable_programmed_initial_priority:1;	/* RW */
+		unsigned long rsvd_29_47:19;	/*    */
+		unsigned long fun:16;	/* RW */
+	} s1;
+	struct uv2h_lb_bau_misc_control_s {
+		unsigned long rejection_delay:8;	/* RW */
+		unsigned long apic_mode:1;	/* RW */
+		unsigned long force_broadcast:1;	/* RW */
+		unsigned long force_lock_nop:1;	/* RW */
+		unsigned long qpi_agent_presence_vector:3;	/* RW */
+		unsigned long descriptor_fetch_mode:1;	/* RW */
+		unsigned long enable_intd_soft_ack_mode:1;	/* RW */
+		unsigned long intd_soft_ack_timeout_period:4;	/* RW */
+		unsigned long enable_dual_mapping_mode:1;	/* RW */
+		unsigned long vga_io_port_decode_enable:1;	/* RW */
+		unsigned long vga_io_port_16_bit_decode:1;	/* RW */
+		unsigned long suppress_dest_registration:1;	/* RW */
+		unsigned long programmed_initial_priority:3;	/* RW */
+		unsigned long use_incoming_priority:1;	/* RW */
+		unsigned long enable_programmed_initial_priority:1;	/* RW */
+		unsigned long enable_automatic_apic_mode_selection:1;	/* RW */
+		unsigned long apic_mode_status:1;	/* RO */
+		unsigned long suppress_interrupts_to_self:1;	/* RW */
+		unsigned long enable_lock_based_system_flush:1;	/* RW */
+		unsigned long enable_extended_sb_status:1;	/* RW */
+		unsigned long suppress_int_prio_udt_to_self:1;	/* RW */
+		unsigned long use_legacy_descriptor_formats:1;	/* RW */
+		unsigned long rsvd_36_47:12;	/*    */
+		unsigned long fun:16;	/* RW */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1062,13 +1062,13 @@ union uvh_lb_bau_misc_control_u {
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INIT_MASK 0x8000000000000000UL
 
 union uvh_lb_bau_sb_activation_control_u {
-    unsigned long	v;
-    struct uvh_lb_bau_sb_activation_control_s {
-	unsigned long	index :  6;  /* RW */
-	unsigned long	rsvd_6_61: 56;  /*    */
-	unsigned long	push  :  1;  /* WP */
-	unsigned long	init  :  1;  /* WP */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_sb_activation_control_s {
+		unsigned long index:6;	/* RW */
+		unsigned long rsvd_6_61:56;	/*    */
+		unsigned long push:1;	/* WP */
+		unsigned long init:1;	/* WP */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1081,10 +1081,10 @@ union uvh_lb_bau_sb_activation_control_u
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_MASK 0xffffffffffffffffUL
 
 union uvh_lb_bau_sb_activation_status_0_u {
-    unsigned long	v;
-    struct uvh_lb_bau_sb_activation_status_0_s {
-	unsigned long	status : 64;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_sb_activation_status_0_s {
+		unsigned long status:64;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1097,10 +1097,10 @@ union uvh_lb_bau_sb_activation_status_0_
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_MASK 0xffffffffffffffffUL
 
 union uvh_lb_bau_sb_activation_status_1_u {
-    unsigned long	v;
-    struct uvh_lb_bau_sb_activation_status_1_s {
-	unsigned long	status : 64;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_sb_activation_status_1_s {
+		unsigned long status:64;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1115,14 +1115,14 @@ union uvh_lb_bau_sb_activation_status_1_
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_NODE_ID_MASK 0x7ffe000000000000UL
 
 union uvh_lb_bau_sb_descriptor_base_u {
-    unsigned long	v;
-    struct uvh_lb_bau_sb_descriptor_base_s {
-	unsigned long	rsvd_0_11    : 12;  /*    */
-	unsigned long	page_address : 31;  /* RW */
-	unsigned long	rsvd_43_48   :  6;  /*    */
-	unsigned long	node_id      : 14;  /* RW */
-	unsigned long	rsvd_63      :  1;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_lb_bau_sb_descriptor_base_s {
+		unsigned long rsvd_0_11:12;	/*    */
+		unsigned long page_address:31;	/* RW */
+		unsigned long rsvd_43_48:6;	/*    */
+		unsigned long node_id:14;	/* RW */
+		unsigned long rsvd_63:1;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1172,38 +1172,38 @@ union uvh_lb_bau_sb_descriptor_base_u {
 #define UV2H_NODE_ID_NI_PORT_MASK 0x3e00000000000000UL
 
 union uvh_node_id_u {
-    unsigned long	v;
-    struct uvh_node_id_s {
-	unsigned long	force1        :  1;  /* RO */
-	unsigned long	manufacturer  : 11;  /* RO */
-	unsigned long	part_number   : 16;  /* RO */
-	unsigned long	revision      :  4;  /* RO */
-	unsigned long	node_id       : 15;  /* RW */
-	unsigned long	rsvd_47_63    : 17;
-    } s;
-    struct uv1h_node_id_s {
-	unsigned long	force1        :  1;  /* RO */
-	unsigned long	manufacturer  : 11;  /* RO */
-	unsigned long	part_number   : 16;  /* RO */
-	unsigned long	revision      :  4;  /* RO */
-	unsigned long	node_id       : 15;  /* RW */
-	unsigned long	rsvd_47       :  1;  /*    */
-	unsigned long	nodes_per_bit :  7;  /* RW */
-	unsigned long	rsvd_55       :  1;  /*    */
-	unsigned long	ni_port       :  4;  /* RO */
-	unsigned long	rsvd_60_63    :  4;  /*    */
-    } s1;
-    struct uv2h_node_id_s {
-	unsigned long	force1        :  1;  /* RO */
-	unsigned long	manufacturer  : 11;  /* RO */
-	unsigned long	part_number   : 16;  /* RO */
-	unsigned long	revision      :  4;  /* RO */
-	unsigned long	node_id       : 15;  /* RW */
-	unsigned long	rsvd_47_49    :  3;  /*    */
-	unsigned long	nodes_per_bit :  7;  /* RO */
-	unsigned long	ni_port       :  5;  /* RO */
-	unsigned long	rsvd_62_63    :  2;  /*    */
-    } s2;
+	unsigned long v;
+	struct uvh_node_id_s {
+		unsigned long force1:1;	/* RO */
+		unsigned long manufacturer:11;	/* RO */
+		unsigned long part_number:16;	/* RO */
+		unsigned long revision:4;	/* RO */
+		unsigned long node_id:15;	/* RW */
+		unsigned long rsvd_47_63:17;
+	} s;
+	struct uv1h_node_id_s {
+		unsigned long force1:1;	/* RO */
+		unsigned long manufacturer:11;	/* RO */
+		unsigned long part_number:16;	/* RO */
+		unsigned long revision:4;	/* RO */
+		unsigned long node_id:15;	/* RW */
+		unsigned long rsvd_47:1;	/*    */
+		unsigned long nodes_per_bit:7;	/* RW */
+		unsigned long rsvd_55:1;	/*    */
+		unsigned long ni_port:4;	/* RO */
+		unsigned long rsvd_60_63:4;	/*    */
+	} s1;
+	struct uv2h_node_id_s {
+		unsigned long force1:1;	/* RO */
+		unsigned long manufacturer:11;	/* RO */
+		unsigned long part_number:16;	/* RO */
+		unsigned long revision:4;	/* RO */
+		unsigned long node_id:15;	/* RW */
+		unsigned long rsvd_47_49:3;	/*    */
+		unsigned long nodes_per_bit:7;	/* RO */
+		unsigned long ni_port:5;	/* RO */
+		unsigned long rsvd_62_63:2;	/*    */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1216,10 +1216,10 @@ union uvh_node_id_u {
 #define UVH_NODE_PRESENT_TABLE_NODES_MASK 0xffffffffffffffffUL
 
 union uvh_node_present_table_u {
-    unsigned long	v;
-    struct uvh_node_present_table_s {
-	unsigned long	nodes : 64;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_node_present_table_s {
+		unsigned long nodes:64;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1235,15 +1235,15 @@ union uvh_node_present_table_u {
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_alias210_overlay_config_0_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_overlay_config_0_mmr_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_overlay_config_0_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long base:8;	/* RW */
+		unsigned long rsvd_32_47:16;	/*    */
+		unsigned long m_alias:5;	/* RW */
+		unsigned long rsvd_53_62:10;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1259,15 +1259,15 @@ union uvh_rh_gam_alias210_overlay_config
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_alias210_overlay_config_1_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_overlay_config_1_mmr_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_overlay_config_1_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long base:8;	/* RW */
+		unsigned long rsvd_32_47:16;	/*    */
+		unsigned long m_alias:5;	/* RW */
+		unsigned long rsvd_53_62:10;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1283,15 +1283,15 @@ union uvh_rh_gam_alias210_overlay_config
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_alias210_overlay_config_2_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_overlay_config_2_mmr_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_overlay_config_2_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long base:8;	/* RW */
+		unsigned long rsvd_32_47:16;	/*    */
+		unsigned long m_alias:5;	/* RW */
+		unsigned long rsvd_53_62:10;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1303,12 +1303,12 @@ union uvh_rh_gam_alias210_overlay_config
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_MASK 0x00003fffff000000UL
 
 union uvh_rh_gam_alias210_redirect_config_0_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_redirect_config_0_mmr_s {
-	unsigned long	rsvd_0_23 : 24;  /*    */
-	unsigned long	dest_base : 22;  /* RW */
-	unsigned long	rsvd_46_63: 18;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_redirect_config_0_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long dest_base:22;	/* RW */
+		unsigned long rsvd_46_63:18;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1320,12 +1320,12 @@ union uvh_rh_gam_alias210_redirect_confi
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR_DEST_BASE_MASK 0x00003fffff000000UL
 
 union uvh_rh_gam_alias210_redirect_config_1_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_redirect_config_1_mmr_s {
-	unsigned long	rsvd_0_23 : 24;  /*    */
-	unsigned long	dest_base : 22;  /* RW */
-	unsigned long	rsvd_46_63: 18;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_redirect_config_1_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long dest_base:22;	/* RW */
+		unsigned long rsvd_46_63:18;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1337,12 +1337,12 @@ union uvh_rh_gam_alias210_redirect_confi
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR_DEST_BASE_MASK 0x00003fffff000000UL
 
 union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_alias210_redirect_config_2_mmr_s {
-	unsigned long	rsvd_0_23 : 24;  /*    */
-	unsigned long	dest_base : 22;  /* RW */
-	unsigned long	rsvd_46_63: 18;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_rh_gam_alias210_redirect_config_2_mmr_s {
+		unsigned long rsvd_0_23:24;	/*    */
+		unsigned long dest_base:22;	/* RW */
+		unsigned long rsvd_46_63:18;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1368,24 +1368,24 @@ union uvh_rh_gam_alias210_redirect_confi
 #define UV2H_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
 
 union uvh_rh_gam_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_config_mmr_s {
-	unsigned long	m_skt     :  6;  /* RW */
-	unsigned long	n_skt     :  4;  /* RW */
-	unsigned long	rsvd_10_63    : 54;
-    } s;
-    struct uv1h_rh_gam_config_mmr_s {
-	unsigned long	m_skt     :  6;  /* RW */
-	unsigned long	n_skt     :  4;  /* RW */
-	unsigned long	rsvd_10_11:  2;  /*    */
-	unsigned long	mmiol_cfg :  1;  /* RW */
-	unsigned long	rsvd_13_63: 51;  /*    */
-    } s1;
-    struct uv2h_rh_gam_config_mmr_s {
-	unsigned long	m_skt :  6;  /* RW */
-	unsigned long	n_skt :  4;  /* RW */
-	unsigned long	rsvd_10_63: 54;  /*    */
-    } s2;
+	unsigned long v;
+	struct uvh_rh_gam_config_mmr_s {
+		unsigned long m_skt:6;	/* RW */
+		unsigned long n_skt:4;	/* RW */
+		unsigned long rsvd_10_63:54;
+	} s;
+	struct uv1h_rh_gam_config_mmr_s {
+		unsigned long m_skt:6;	/* RW */
+		unsigned long n_skt:4;	/* RW */
+		unsigned long rsvd_10_11:2;	/*    */
+		unsigned long mmiol_cfg:1;	/* RW */
+		unsigned long rsvd_13_63:51;	/*    */
+	} s1;
+	struct uv2h_rh_gam_config_mmr_s {
+		unsigned long m_skt:6;	/* RW */
+		unsigned long n_skt:4;	/* RW */
+		unsigned long rsvd_10_63:54;	/*    */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1413,31 +1413,31 @@ union uvh_rh_gam_config_mmr_u {
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_gru_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_gru_overlay_config_mmr_s {
-	unsigned long	rsvd_0_27: 28;  /*    */
-	unsigned long	base   : 18;  /* RW */
-	unsigned long	rsvd_46_62    : 17;
-	unsigned long	enable :  1;  /* RW */
-    } s;
-    struct uv1h_rh_gam_gru_overlay_config_mmr_s {
-	unsigned long	rsvd_0_27: 28;  /*    */
-	unsigned long	base   : 18;  /* RW */
-	unsigned long	rsvd_46_47:  2;  /*    */
-	unsigned long	gr4    :  1;  /* RW */
-	unsigned long	rsvd_49_51:  3;  /*    */
-	unsigned long	n_gru  :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s1;
-    struct uv2h_rh_gam_gru_overlay_config_mmr_s {
-	unsigned long	rsvd_0_27: 28;  /*    */
-	unsigned long	base   : 18;  /* RW */
-	unsigned long	rsvd_46_51:  6;  /*    */
-	unsigned long	n_gru  :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s2;
+	unsigned long v;
+	struct uvh_rh_gam_gru_overlay_config_mmr_s {
+		unsigned long rsvd_0_27:28;	/*    */
+		unsigned long base:18;	/* RW */
+		unsigned long rsvd_46_62:17;
+		unsigned long enable:1;	/* RW */
+	} s;
+	struct uv1h_rh_gam_gru_overlay_config_mmr_s {
+		unsigned long rsvd_0_27:28;	/*    */
+		unsigned long base:18;	/* RW */
+		unsigned long rsvd_46_47:2;	/*    */
+		unsigned long gr4:1;	/* RW */
+		unsigned long rsvd_49_51:3;	/*    */
+		unsigned long n_gru:4;	/* RW */
+		unsigned long rsvd_56_62:7;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s1;
+	struct uv2h_rh_gam_gru_overlay_config_mmr_s {
+		unsigned long rsvd_0_27:28;	/*    */
+		unsigned long base:18;	/* RW */
+		unsigned long rsvd_46_51:6;	/*    */
+		unsigned long n_gru:4;	/* RW */
+		unsigned long rsvd_56_62:7;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1464,23 +1464,23 @@ union uvh_rh_gam_gru_overlay_config_mmr_
 #define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmioh_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uv1h_rh_gam_mmioh_overlay_config_mmr_s {
-	unsigned long	rsvd_0_29: 30;  /*    */
-	unsigned long	base   : 16;  /* RW */
-	unsigned long	m_io   :  6;  /* RW */
-	unsigned long	n_io   :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s1;
-    struct uv2h_rh_gam_mmioh_overlay_config_mmr_s {
-	unsigned long	rsvd_0_26: 27;  /*    */
-	unsigned long	base   : 19;  /* RW */
-	unsigned long	m_io   :  6;  /* RW */
-	unsigned long	n_io   :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s2;
+	unsigned long v;
+	struct uv1h_rh_gam_mmioh_overlay_config_mmr_s {
+		unsigned long rsvd_0_29:30;	/*    */
+		unsigned long base:16;	/* RW */
+		unsigned long m_io:6;	/* RW */
+		unsigned long n_io:4;	/* RW */
+		unsigned long rsvd_56_62:7;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s1;
+	struct uv2h_rh_gam_mmioh_overlay_config_mmr_s {
+		unsigned long rsvd_0_26:27;	/*    */
+		unsigned long base:19;	/* RW */
+		unsigned long m_io:6;	/* RW */
+		unsigned long n_io:4;	/* RW */
+		unsigned long rsvd_56_62:7;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1504,26 +1504,26 @@ union uvh_rh_gam_mmioh_overlay_config_mm
 #define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmr_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_mmr_overlay_config_mmr_s {
-	unsigned long	rsvd_0_25: 26;  /*    */
-	unsigned long	base     : 20;  /* RW */
-	unsigned long	rsvd_46_62    : 17;
-	unsigned long	enable   :  1;  /* RW */
-    } s;
-    struct uv1h_rh_gam_mmr_overlay_config_mmr_s {
-	unsigned long	rsvd_0_25: 26;  /*    */
-	unsigned long	base     : 20;  /* RW */
-	unsigned long	dual_hub :  1;  /* RW */
-	unsigned long	rsvd_47_62: 16;  /*    */
-	unsigned long	enable   :  1;  /* RW */
-    } s1;
-    struct uv2h_rh_gam_mmr_overlay_config_mmr_s {
-	unsigned long	rsvd_0_25: 26;  /*    */
-	unsigned long	base   : 20;  /* RW */
-	unsigned long	rsvd_46_62: 17;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s2;
+	unsigned long v;
+	struct uvh_rh_gam_mmr_overlay_config_mmr_s {
+		unsigned long rsvd_0_25:26;	/*    */
+		unsigned long base:20;	/* RW */
+		unsigned long rsvd_46_62:17;
+		unsigned long enable:1;	/* RW */
+	} s;
+	struct uv1h_rh_gam_mmr_overlay_config_mmr_s {
+		unsigned long rsvd_0_25:26;	/*    */
+		unsigned long base:20;	/* RW */
+		unsigned long dual_hub:1;	/* RW */
+		unsigned long rsvd_47_62:16;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s1;
+	struct uv2h_rh_gam_mmr_overlay_config_mmr_s {
+		unsigned long rsvd_0_25:26;	/*    */
+		unsigned long base:20;	/* RW */
+		unsigned long rsvd_46_62:17;	/*    */
+		unsigned long enable:1;	/* RW */
+	} s2;
 };
 
 /* ========================================================================= */
@@ -1535,11 +1535,11 @@ union uvh_rh_gam_mmr_overlay_config_mmr_
 #define UVH_RTC_REAL_TIME_CLOCK_MASK 0x00ffffffffffffffUL
 
 union uvh_rtc_u {
-    unsigned long	v;
-    struct uvh_rtc_s {
-	unsigned long	real_time_clock : 56;  /* RW */
-	unsigned long	rsvd_56_63      :  8;  /*    */
-    } s;
+	unsigned long v;
+	struct uvh_rtc_s {
+		unsigned long real_time_clock:56;	/* RW */
+		unsigned long rsvd_56_63:8;	/*    */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1565,19 +1565,19 @@ union uvh_rtc_u {
 #define UVH_RTC1_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
 
 union uvh_rtc1_int_config_u {
-    unsigned long	v;
-    struct uvh_rtc1_int_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
+	unsigned long v;
+	struct uvh_rtc1_int_config_s {
+		unsigned long vector_:8;	/* RW */
+		unsigned long dm:3;	/* RW */
+		unsigned long destmode:1;	/* RW */
+		unsigned long status:1;	/* RO */
+		unsigned long p:1;	/* RO */
+		unsigned long rsvd_14:1;	/*    */
+		unsigned long t:1;	/* RO */
+		unsigned long m:1;	/* RW */
+		unsigned long rsvd_17_31:15;	/*    */
+		unsigned long apic_id:32;	/* RW */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1590,10 +1590,10 @@ union uvh_rtc1_int_config_u {
 #define UVH_SCRATCH5_SCRATCH5_MASK 0xffffffffffffffffUL
 
 union uvh_scratch5_u {
-    unsigned long	v;
-    struct uvh_scratch5_s {
-	unsigned long	scratch5 : 64;  /* RW, W1CS */
-    } s;
+	unsigned long v;
+	struct uvh_scratch5_s {
+		unsigned long scratch5:64;	/* RW, W1CS */
+	} s;
 };
 
 /* ========================================================================= */
@@ -1668,42 +1668,42 @@ union uvh_scratch5_u {
 #define UV2H_EVENT_OCCURRED2_RTC_31_MASK 0x0000000080000000UL
 
 union uv2h_event_occurred2_u {
-    unsigned long	v;
-    struct uv2h_event_occurred2_s {
-	unsigned long	rtc_0  :  1;  /* RW */
-	unsigned long	rtc_1  :  1;  /* RW */
-	unsigned long	rtc_2  :  1;  /* RW */
-	unsigned long	rtc_3  :  1;  /* RW */
-	unsigned long	rtc_4  :  1;  /* RW */
-	unsigned long	rtc_5  :  1;  /* RW */
-	unsigned long	rtc_6  :  1;  /* RW */
-	unsigned long	rtc_7  :  1;  /* RW */
-	unsigned long	rtc_8  :  1;  /* RW */
-	unsigned long	rtc_9  :  1;  /* RW */
-	unsigned long	rtc_10 :  1;  /* RW */
-	unsigned long	rtc_11 :  1;  /* RW */
-	unsigned long	rtc_12 :  1;  /* RW */
-	unsigned long	rtc_13 :  1;  /* RW */
-	unsigned long	rtc_14 :  1;  /* RW */
-	unsigned long	rtc_15 :  1;  /* RW */
-	unsigned long	rtc_16 :  1;  /* RW */
-	unsigned long	rtc_17 :  1;  /* RW */
-	unsigned long	rtc_18 :  1;  /* RW */
-	unsigned long	rtc_19 :  1;  /* RW */
-	unsigned long	rtc_20 :  1;  /* RW */
-	unsigned long	rtc_21 :  1;  /* RW */
-	unsigned long	rtc_22 :  1;  /* RW */
-	unsigned long	rtc_23 :  1;  /* RW */
-	unsigned long	rtc_24 :  1;  /* RW */
-	unsigned long	rtc_25 :  1;  /* RW */
-	unsigned long	rtc_26 :  1;  /* RW */
-	unsigned long	rtc_27 :  1;  /* RW */
-	unsigned long	rtc_28 :  1;  /* RW */
-	unsigned long	rtc_29 :  1;  /* RW */
-	unsigned long	rtc_30 :  1;  /* RW */
-	unsigned long	rtc_31 :  1;  /* RW */
-	unsigned long	rsvd_32_63: 32;  /*    */
-    } s1;
+	unsigned long v;
+	struct uv2h_event_occurred2_s {
+		unsigned long rtc_0:1;	/* RW */
+		unsigned long rtc_1:1;	/* RW */
+		unsigned long rtc_2:1;	/* RW */
+		unsigned long rtc_3:1;	/* RW */
+		unsigned long rtc_4:1;	/* RW */
+		unsigned long rtc_5:1;	/* RW */
+		unsigned long rtc_6:1;	/* RW */
+		unsigned long rtc_7:1;	/* RW */
+		unsigned long rtc_8:1;	/* RW */
+		unsigned long rtc_9:1;	/* RW */
+		unsigned long rtc_10:1;	/* RW */
+		unsigned long rtc_11:1;	/* RW */
+		unsigned long rtc_12:1;	/* RW */
+		unsigned long rtc_13:1;	/* RW */
+		unsigned long rtc_14:1;	/* RW */
+		unsigned long rtc_15:1;	/* RW */
+		unsigned long rtc_16:1;	/* RW */
+		unsigned long rtc_17:1;	/* RW */
+		unsigned long rtc_18:1;	/* RW */
+		unsigned long rtc_19:1;	/* RW */
+		unsigned long rtc_20:1;	/* RW */
+		unsigned long rtc_21:1;	/* RW */
+		unsigned long rtc_22:1;	/* RW */
+		unsigned long rtc_23:1;	/* RW */
+		unsigned long rtc_24:1;	/* RW */
+		unsigned long rtc_25:1;	/* RW */
+		unsigned long rtc_26:1;	/* RW */
+		unsigned long rtc_27:1;	/* RW */
+		unsigned long rtc_28:1;	/* RW */
+		unsigned long rtc_29:1;	/* RW */
+		unsigned long rtc_30:1;	/* RW */
+		unsigned long rtc_31:1;	/* RW */
+		unsigned long rsvd_32_63:32;	/*    */
+	} s1;
 };
 
 /* ========================================================================= */
@@ -1722,10 +1722,10 @@ union uv2h_event_occurred2_u {
 #define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
 
 union uv2h_lb_bau_sb_activation_status_2_u {
-    unsigned long	v;
-    struct uv2h_lb_bau_sb_activation_status_2_s {
-	unsigned long	aux_error : 64;  /* RW */
-    } s1;
+	unsigned long v;
+	struct uv2h_lb_bau_sb_activation_status_2_s {
+		unsigned long aux_error:64;	/* RW */
+	} s1;
 };
 
 /* ========================================================================= */
@@ -1738,12 +1738,11 @@ union uv2h_lb_bau_sb_activation_status_2
 #define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
 
 union uv1h_lb_target_physical_apic_id_mask_u {
-    unsigned long	v;
-    struct uv1h_lb_target_physical_apic_id_mask_s {
-	unsigned long	bit_enables : 32;  /* RW */
-	unsigned long	rsvd_32_63  : 32;  /*    */
-    } s1;
+	unsigned long v;
+	struct uv1h_lb_target_physical_apic_id_mask_s {
+		unsigned long bit_enables:32;	/* RW */
+		unsigned long rsvd_32_63:32;	/*    */
+	} s1;
 };
 
-
 #endif /* __ASM_UV_MMRS_X86_H__ */
