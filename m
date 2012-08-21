Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2HURMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:12:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HURM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:12:28 -0400
Message-ID: <1345569116.26596.4.camel@twins>
Subject: Re: [tip:perf/core] perf: Add ability to attach user stack dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, eranian@google.com, acme@redhat.com, gorcunov@openvz.org,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 21 Aug 2012 19:11:56 +0200
In-Reply-To: <tip-c5ebcedb566ef17bda7b02686e0d658a7bb42ee7@git.kernel.org>
References: <1344345647-11536-6-git-send-email-jolsa@redhat.com>
	 <tip-c5ebcedb566ef17bda7b02686e0d658a7bb42ee7@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 08:49 -0700, tip-bot for Jiri Olsa wrote:
>  #define PERF_ATTR_SIZE_VER3    88      /* add: sample_regs_user */
> +#define PERF_ATTR_SIZE_VER4    96      /* add: sample_stack_user */

Both are introduced in this patch set, there's no release in between,
why are we doing two version increments? Seems like pointless version
space inflation to me.


