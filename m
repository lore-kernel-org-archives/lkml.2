Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2DNKWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:22:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34277 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2DNKWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:22:20 -0400
Message-ID: <1334398930.2528.50.camel@twins>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Apr 2012 12:22:10 +0200
In-Reply-To: <1333390758-10893-7-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> + * IbsOpCntCtl (bit 19) of IBS Execution Control Register (IbsOpCtl,
> + * MSRC001_1033) is used to select either cycle or micro-ops counting
> + * mode. 

Ah is that what it does.. the BKDG doesn't appear to say this.
