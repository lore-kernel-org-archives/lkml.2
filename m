Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2HURMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:12:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:49349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HURMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:12:49 -0400
Message-ID: <1345569130.26596.5.camel@twins>
Subject: Re: [tip:perf/core] perf tools: Adding PERF_ATTR_SIZE_VER2 to the
 header swap check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, eranian@google.com, acme@redhat.com, gorcunov@openvz.org,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 21 Aug 2012 19:12:10 +0200
In-Reply-To: <tip-239cc47819ec5e1acde42d416755c332ed5cf2c8@git.kernel.org>
References: <1344345647-11536-8-git-send-email-jolsa@redhat.com>
	 <tip-239cc47819ec5e1acde42d416755c332ed5cf2c8@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 08:51 -0700, tip-bot for Jiri Olsa wrote:
> @@ -1829,6 +1829,7 @@ out_free:
>  static const int attr_file_abi_sizes[] = {
>         [0] = PERF_ATTR_SIZE_VER0,
>         [1] = PERF_ATTR_SIZE_VER1,
> +       [2] = PERF_ATTR_SIZE_VER2,
>         0,
>  }; 

Didn't we just get to VER4 ?
