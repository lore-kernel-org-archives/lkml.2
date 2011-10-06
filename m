Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159Ab1JFRBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:01:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab1JFRBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:01:39 -0400
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 19:01:26 +0200
In-Reply-To: <1317912555-9559-2-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317920486.29658.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> +enum perf_branch_sample_type {
> +       PERF_SAMPLE_BRANCH_USER         = 1U << 0, /* user level branches */
> +       PERF_SAMPLE_BRANCH_KERNEL       = 1U << 1, /* kernel level branches */


I just merged a patch-set that adds guest/host muck as well, would it
make sense to extend this stuff to support that as well?

> +       PERF_SAMPLE_BRANCH_ANY          = 1U << 2, /* any branch types */
> +       PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << 3, /* any call branch */
> +       PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << 4, /* any return branch */
> +       PERF_SAMPLE_BRANCH_IND_CALL     = 1U << 5, /* indirect calls */
> +
> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 6,/* non-ABI */
> +} 
