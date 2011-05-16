Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1EPJoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:44:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EPJoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:44:02 -0400
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110503092904.806273470@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.806273470@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 11:43:40 +0200
Message-ID: <1305539020.2466.4063.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> This behavior may be disabled (allowing child bandwidth to exceed parent) via
> kernel.sched_cfs_bandwidth_consistent=0

why? this needs very good justification.
