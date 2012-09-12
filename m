Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2ILLVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:21:30 -0400
Received: from [205.233.59.134] ([205.233.59.134]:56315 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2ILLV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:21:29 -0400
Message-ID: <1347448843.15764.3.camel@twins>
Subject: Re: [PATCH] perf: Introduce function to report unsupported syscall
 attribute flags
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Sep 2012 13:20:43 +0200
In-Reply-To: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
References: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 13:01 +0200, Robert Richter wrote:
> +       if (notsup)
> +               pr_warn("perf: unsupported attribute flags: %016llx\n", notsup); 

This is a dmesg DoS..

I'm also not sure dmesg is the right way.. could we not somehow change
the attrs to provide better diagnostic?
