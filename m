Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2LQNiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:38:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2LQNhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:37:34 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] perf tool: Add non arch events for SandyBridge microarchitecture
Date: Mon, 17 Dec 2012 14:37:05 +0100
Message-Id: <1355751425-7993-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding non architectural event aliases for Sandy Bridge
microarchitecture.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/arch/x86/Makefile                                          | 4 ++++
 tools/perf/arch/x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT        | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.COND        | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP  | 1 +
 .../arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL   | 1 +
 .../events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET   | 1 +
 .../arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.TAKEN       | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.COND        | 1 +
 .../arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL   | 1 +
 .../events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET   | 1 +
 .../arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.TAKEN       | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING0         | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING123       | 1 +
 .../x86/events/intel/SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK     | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P  | 1 +
 .../x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT  | 1 +
 .../arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED | 1 +
 .../arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION  | 1 +
 .../x86/events/intel/SandyBridge/DTLB_STORE_MISSES.MISS_CAUSES_A_WALK | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT | 1 +
 .../x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED     | 1 +
 .../arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_DURATION | 1 +
 .../x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE | 1 +
 .../x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE | 1 +
 .../x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE    | 1 +
 .../x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.X87      | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS      | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/ICACHE.MISSES            | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS             | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.EMPTY                | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MITE_UOPS            | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS          | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS         | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS              | 1 +
 .../arch/x86/events/intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL        | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.LCP            | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RECOVERY_CYCLES | 1 +
 .../arch/x86/events/intel/SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.STLB_HIT     | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_DURATION  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALLOCATED_IN_M       | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L1D.EVICTION             | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L1D.REPLACEMENT          | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L1D_PEND_MISS.PENDING    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL      | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S    | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD     | 1 +
 .../arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF          | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO         | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS    | 1 +
 .../arch/x86/events/intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT          | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS         | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS        | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS        | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK      | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN   | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR          | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.STORE_FORWARD  | 1 +
 .../arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS | 1 +
 .../arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF       | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF       | 1 +
 .../arch/x86/events/intel/SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION | 1 +
 .../events/intel/SandyBridge/LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.MISS   | 1 +
 .../arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE     | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.LOADS   | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.STORES  | 1 +
 .../events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD | 1 +
 .../intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD     | 1 +
 .../events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO  | 1 +
 .../x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP   | 1 +
 .../x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP    | 1 +
 .../x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW   | 1 +
 .../arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY   | 1 +
 .../x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL     | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES   | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE  | 1 +
 .../perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE  | 1 +
 tools/perf/arch/x86/events/intel/SandyBridge/UOPS_ISSUED.ANY          | 1 +
 107 files changed, 110 insertions(+)
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.COND
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.TAKEN
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.COND
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.TAKEN
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING0
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING123
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.MISS_CAUSES_A_WALK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_DURATION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.X87
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ICACHE.MISSES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.EMPTY
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MITE_UOPS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.LCP
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RECOVERY_CYCLES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.STLB_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_DURATION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALLOCATED_IN_M
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L1D.EVICTION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L1D.REPLACEMENT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L1D_PEND_MISS.PENDING
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.STORE_FORWARD
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.MISS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.LOADS
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.STORES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE
 create mode 100644 tools/perf/arch/x86/events/intel/SandyBridge/UOPS_ISSUED.ANY

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index c175f65..5aa5e06 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -13,3 +13,7 @@ $(OUTPUT)$(OUTPUT)arch/$(ARCH)/util/pmu.o: $(OUTPUT)arch/$(ARCH)/util/pmu.c $(OU
 	 '-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
 	 '-DPREFIX="$(prefix_SQ)"' \
 	 $<
+
+install:
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/events/x86/intel/SandyBridge'
+	$(INSTALL) -m 644 arch/$(ARCH)/events/intel/SandyBridge/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/events/x86/intel/SandyBridge/'
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT b/tools/perf/arch/x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT
new file mode 100644
index 0000000..848c5cc
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT
@@ -0,0 +1 @@
+event=0x14,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES
new file mode 100644
index 0000000..d4c8594
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES
@@ -0,0 +1 @@
+event=0x88,umask=0xff
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.COND b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.COND
new file mode 100644
index 0000000..be6ab16
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.COND
@@ -0,0 +1 @@
+event=0x88,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP
new file mode 100644
index 0000000..d9896ac
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP
@@ -0,0 +1 @@
+event=0x88,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL
new file mode 100644
index 0000000..5a14f1e
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL
@@ -0,0 +1 @@
+event=0x88,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET
new file mode 100644
index 0000000..61b209f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET
@@ -0,0 +1 @@
+event=0x88,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL
new file mode 100644
index 0000000..a9a05a0
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL
@@ -0,0 +1 @@
+event=0x88,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN
new file mode 100644
index 0000000..7042e0c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN
@@ -0,0 +1 @@
+event=0x88,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR
new file mode 100644
index 0000000..31b35ac
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR
@@ -0,0 +1 @@
+event=0x88,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.TAKEN b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.TAKEN
new file mode 100644
index 0000000..d9aca88
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_INST_EXEC.TAKEN
@@ -0,0 +1 @@
+event=0x88,umask=0x80
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES
new file mode 100644
index 0000000..a65240f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES
@@ -0,0 +1 @@
+event=0x89,umask=0xff
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.COND b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.COND
new file mode 100644
index 0000000..47f455b
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.COND
@@ -0,0 +1 @@
+event=0x89,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL
new file mode 100644
index 0000000..f74bd8e
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL
@@ -0,0 +1 @@
+event=0x89,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET
new file mode 100644
index 0000000..e3caba5
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET
@@ -0,0 +1 @@
+event=0x89,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL
new file mode 100644
index 0000000..530436c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL
@@ -0,0 +1 @@
+event=0x89,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN
new file mode 100644
index 0000000..d074871
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN
@@ -0,0 +1 @@
+event=0x89,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR
new file mode 100644
index 0000000..8791133
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR
@@ -0,0 +1 @@
+event=0x89,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.TAKEN b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.TAKEN
new file mode 100644
index 0000000..b99bd46
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/BR_MISP_EXEC.TAKEN
@@ -0,0 +1 @@
+event=0x89,umask=0x80
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING0 b/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING0
new file mode 100644
index 0000000..8103f9c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING0
@@ -0,0 +1 @@
+event=0x5c,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING123 b/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING123
new file mode 100644
index 0000000..c08f3f1
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/CPL_CYCLES.RING123
@@ -0,0 +1 @@
+event=0x5c,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK b/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK
new file mode 100644
index 0000000..5e9a032
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK
@@ -0,0 +1 @@
+event=0x3c,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P b/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P
new file mode 100644
index 0000000..41f221b
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P
@@ -0,0 +1 @@
+event=0x3c,umask=0x0
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK
new file mode 100644
index 0000000..4c49a79
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK
@@ -0,0 +1 @@
+event=0x8,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT
new file mode 100644
index 0000000..a0ef5aa
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT
@@ -0,0 +1 @@
+event=0x8,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED
new file mode 100644
index 0000000..78c3024
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED
@@ -0,0 +1 @@
+event=0x8,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION
new file mode 100644
index 0000000..bfcf2a4
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION
@@ -0,0 +1 @@
+event=0x8,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.MISS_CAUSES_A_WALK b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.MISS_CAUSES_A_WALK
new file mode 100644
index 0000000..2517178
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.MISS_CAUSES_A_WALK
@@ -0,0 +1 @@
+event=0x49,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT
new file mode 100644
index 0000000..669b234
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT
@@ -0,0 +1 @@
+event=0x49,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED
new file mode 100644
index 0000000..3014650
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED
@@ -0,0 +1 @@
+event=0x49,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_DURATION b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_DURATION
new file mode 100644
index 0000000..4fe198a
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/DTLB_STORE_MISSES.WALK_DURATION
@@ -0,0 +1 @@
+event=0x49,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE
new file mode 100644
index 0000000..dd34532
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE
@@ -0,0 +1 @@
+event=0x10,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE
new file mode 100644
index 0000000..55f6c39
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE
@@ -0,0 +1 @@
+event=0x10,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE
new file mode 100644
index 0000000..5336605
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE
@@ -0,0 +1 @@
+event=0x10,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE
new file mode 100644
index 0000000..ea05109e
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE
@@ -0,0 +1 @@
+event=0x10,umask=0x80
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.X87 b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.X87
new file mode 100644
index 0000000..e8fbc879
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/FP_COMP_OPS_EXE.X87
@@ -0,0 +1 @@
+event=0x10,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS b/tools/perf/arch/x86/events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS
new file mode 100644
index 0000000..87ae6c5
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS
@@ -0,0 +1 @@
+event=0x4e,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ICACHE.MISSES b/tools/perf/arch/x86/events/intel/SandyBridge/ICACHE.MISSES
new file mode 100644
index 0000000..952b3b5
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ICACHE.MISSES
@@ -0,0 +1 @@
+event=0x80,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS
new file mode 100644
index 0000000..5f7f9e4
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS
@@ -0,0 +1 @@
+event=0x79,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.EMPTY b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.EMPTY
new file mode 100644
index 0000000..bf02969
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.EMPTY
@@ -0,0 +1 @@
+event=0x79,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MITE_UOPS b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MITE_UOPS
new file mode 100644
index 0000000..eff6d32
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MITE_UOPS
@@ -0,0 +1 @@
+event=0x79,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS
new file mode 100644
index 0000000..a6a688f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS
@@ -0,0 +1 @@
+event=0x79,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS
new file mode 100644
index 0000000..e6883aa
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS
@@ -0,0 +1 @@
+event=0x79,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS
new file mode 100644
index 0000000..684f0cd
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS
@@ -0,0 +1 @@
+event=0x79,umask=0x30
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE
new file mode 100644
index 0000000..f6ba68a
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE
@@ -0,0 +1 @@
+event=0x9c,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL b/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL
new file mode 100644
index 0000000..93863b6
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL
@@ -0,0 +1 @@
+event=0x87,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.LCP b/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.LCP
new file mode 100644
index 0000000..ef6784d
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ILD_STALL.LCP
@@ -0,0 +1 @@
+event=0x87,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS b/tools/perf/arch/x86/events/intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS
new file mode 100644
index 0000000..792774c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS
@@ -0,0 +1 @@
+event=0x17,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES b/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES
new file mode 100644
index 0000000..dd26cf7
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES
@@ -0,0 +1 @@
+event=0xd,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RECOVERY_CYCLES b/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RECOVERY_CYCLES
new file mode 100644
index 0000000..ce54bb4
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/INT_MISC.RECOVERY_CYCLES
@@ -0,0 +1 @@
+event=0xd,umask=0x3
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK
new file mode 100644
index 0000000..66e49cb
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK
@@ -0,0 +1 @@
+event=0x85,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.STLB_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.STLB_HIT
new file mode 100644
index 0000000..7b2d808
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.STLB_HIT
@@ -0,0 +1 @@
+event=0x85,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED
new file mode 100644
index 0000000..4de9121
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED
@@ -0,0 +1 @@
+event=0x85,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_DURATION b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_DURATION
new file mode 100644
index 0000000..81fd533
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/ITLB_MISSES.WALK_DURATION
@@ -0,0 +1 @@
+event=0x85,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALLOCATED_IN_M b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALLOCATED_IN_M
new file mode 100644
index 0000000..673bbf2
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALLOCATED_IN_M
@@ -0,0 +1 @@
+event=0x51,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT
new file mode 100644
index 0000000..a229d2a
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT
@@ -0,0 +1 @@
+event=0x51,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L1D.EVICTION b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.EVICTION
new file mode 100644
index 0000000..c81af2b
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.EVICTION
@@ -0,0 +1 @@
+event=0x51,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L1D.REPLACEMENT b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.REPLACEMENT
new file mode 100644
index 0000000..98df40c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L1D.REPLACEMENT
@@ -0,0 +1 @@
+event=0x51,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L1D_PEND_MISS.PENDING b/tools/perf/arch/x86/events/intel/SandyBridge/L1D_PEND_MISS.PENDING
new file mode 100644
index 0000000..ee415b7
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L1D_PEND_MISS.PENDING
@@ -0,0 +1 @@
+event=0x48,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL
new file mode 100644
index 0000000..d78d6b3
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL
@@ -0,0 +1 @@
+event=0x28,umask=0xf
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E
new file mode 100644
index 0000000..5e16e34
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E
@@ -0,0 +1 @@
+event=0x28,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M
new file mode 100644
index 0000000..5a2669f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M
@@ -0,0 +1 @@
+event=0x28,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S
new file mode 100644
index 0000000..7b1f305
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S
@@ -0,0 +1 @@
+event=0x28,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS
new file mode 100644
index 0000000..f3d15b2
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS
@@ -0,0 +1 @@
+event=0x28,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD
new file mode 100644
index 0000000..9774607
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD
@@ -0,0 +1 @@
+event=0x24,umask=0x30
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD
new file mode 100644
index 0000000..8ecaf00
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD
@@ -0,0 +1 @@
+event=0x24,umask=0x3
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF
new file mode 100644
index 0000000..e8c9bc1
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF
@@ -0,0 +1 @@
+event=0x24,umask=0xc0
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO
new file mode 100644
index 0000000..fc683ae
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO
@@ -0,0 +1 @@
+event=0x24,umask=0xc
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT
new file mode 100644
index 0000000..706e256
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT
@@ -0,0 +1 @@
+event=0x24,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS
new file mode 100644
index 0000000..0de0208
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS
@@ -0,0 +1 @@
+event=0x24,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT
new file mode 100644
index 0000000..048c358
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT
@@ -0,0 +1 @@
+event=0x24,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT
new file mode 100644
index 0000000..dc9b072
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT
@@ -0,0 +1 @@
+event=0x24,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS
new file mode 100644
index 0000000..42699ad
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS
@@ -0,0 +1 @@
+event=0x24,umask=0x80
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS
new file mode 100644
index 0000000..501325c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS
@@ -0,0 +1 @@
+event=0x24,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS
new file mode 100644
index 0000000..db9ae2d
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS
@@ -0,0 +1 @@
+event=0x24,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL
new file mode 100644
index 0000000..8268b73
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL
@@ -0,0 +1 @@
+event=0x27,umask=0xf
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E
new file mode 100644
index 0000000..aaa3478
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E
@@ -0,0 +1 @@
+event=0x27,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M
new file mode 100644
index 0000000..922f0f6
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M
@@ -0,0 +1 @@
+event=0x27,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS
new file mode 100644
index 0000000..173251f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS
@@ -0,0 +1 @@
+event=0x27,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK
new file mode 100644
index 0000000..4fd03d9
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK
@@ -0,0 +1 @@
+event=0x3,umask=0x10
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN
new file mode 100644
index 0000000..db0f3a0
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN
@@ -0,0 +1 @@
+event=0x3,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR
new file mode 100644
index 0000000..c5c5263
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR
@@ -0,0 +1 @@
+event=0x3,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.STORE_FORWARD b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.STORE_FORWARD
new file mode 100644
index 0000000..290a930
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS.STORE_FORWARD
@@ -0,0 +1 @@
+event=0x3,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS
new file mode 100644
index 0000000..585a9d3
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS
@@ -0,0 +1 @@
+event=0x7,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK
new file mode 100644
index 0000000..b6e3a04
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK
@@ -0,0 +1 @@
+event=0x7,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF b/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF
new file mode 100644
index 0000000..4699d32
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF
@@ -0,0 +1 @@
+event=0x4c,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF b/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF
new file mode 100644
index 0000000..cd59610
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF
@@ -0,0 +1 @@
+event=0x4c,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION b/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION
new file mode 100644
index 0000000..888f06f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION
@@ -0,0 +1 @@
+event=0x63,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION b/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION
new file mode 100644
index 0000000..9ee63d0
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION
@@ -0,0 +1 @@
+event=0x63,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.MISS b/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.MISS
new file mode 100644
index 0000000..02a011f
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.MISS
@@ -0,0 +1 @@
+event=0x2e,umask=0x41
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE b/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE
new file mode 100644
index 0000000..d7d2ae9
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE
@@ -0,0 +1 @@
+event=0x2e,umask=0x4f
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.LOADS b/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.LOADS
new file mode 100644
index 0000000..efcfc2b
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.LOADS
@@ -0,0 +1 @@
+event=0x5,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.STORES b/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.STORES
new file mode 100644
index 0000000..26d77f4
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/MISALIGN_MEM_REF.STORES
@@ -0,0 +1 @@
+event=0x5,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD
new file mode 100644
index 0000000..1149577
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD
@@ -0,0 +1 @@
+event=0x60,umask=0x8
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD
new file mode 100644
index 0000000..54c256b
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD
@@ -0,0 +1 @@
+event=0x60,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO
new file mode 100644
index 0000000..24fc7b3
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO
@@ -0,0 +1 @@
+event=0x60,umask=0x4
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP
new file mode 100644
index 0000000..27ba1d8
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP
@@ -0,0 +1 @@
+event=0x59,umask=0x20
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP
new file mode 100644
index 0000000..397928e
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP
@@ -0,0 +1 @@
+event=0x59,umask=0x80
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW
new file mode 100644
index 0000000..f14229c
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW
@@ -0,0 +1 @@
+event=0x59,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY
new file mode 100644
index 0000000..597be5a
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY
@@ -0,0 +1 @@
+event=0x5b,umask=0xc
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL
new file mode 100644
index 0000000..6f86552
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL
@@ -0,0 +1 @@
+event=0x5b,umask=0xf
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL
new file mode 100644
index 0000000..f16a284
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL
@@ -0,0 +1 @@
+event=0x5b,umask=0x40
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC
new file mode 100644
index 0000000..d6882a1
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC
@@ -0,0 +1 @@
+event=0x5b,umask=0x4f
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES b/tools/perf/arch/x86/events/intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES
new file mode 100644
index 0000000..b7d43d3
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES
@@ -0,0 +1 @@
+event=0x5e,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE b/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE
new file mode 100644
index 0000000..9e9b2c2
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE
@@ -0,0 +1 @@
+event=0x11,umask=0x2
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE b/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE
new file mode 100644
index 0000000..233110e
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE
@@ -0,0 +1 @@
+event=0x11,umask=0x1
diff --git a/tools/perf/arch/x86/events/intel/SandyBridge/UOPS_ISSUED.ANY b/tools/perf/arch/x86/events/intel/SandyBridge/UOPS_ISSUED.ANY
new file mode 100644
index 0000000..ea46967
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/SandyBridge/UOPS_ISSUED.ANY
@@ -0,0 +1 @@
+event=0xe,umask=0x1
-- 
1.7.11.7

