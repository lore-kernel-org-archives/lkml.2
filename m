Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168Ab1JFRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:25:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51492 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab1JFRZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:25:23 -0400
Subject: Re: [PATCH 04/12] perf_events: sync branch stack sampling with X86
 precise_sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 19:25:09 +0200
In-Reply-To: <1317912555-9559-5-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-5-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317921909.29658.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> 
> On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
> therefore both features must be coordinated as they may not
> configure LBR the same way. 

Differently, you mean? Both wanting the same configuration seems fine.
