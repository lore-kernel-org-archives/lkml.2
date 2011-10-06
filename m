Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab1JFPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:32:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50341 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab1JFPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:32:30 -0400
Date: Thu, 6 Oct 2011 17:32:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, andi@firstfloor.org,
        robert.richter@amd.com, ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Message-ID: <20111006153229.GJ14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317912555-9559-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	kernel_insn_init(&insn, kaddr);
> +	insn_get_opcode(&insn);

This makes me uncomfortable. AFAIK that's the first use of the opcode
decoder being used directly for user space. It has a quite large attack
surface. Who says it cannot be exploited?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
