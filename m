Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2J2PXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:23:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:42475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2J2PXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:23:20 -0400
Message-ID: <1351524186.24721.29.camel@twins>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Date: Mon, 29 Oct 2012 16:23:06 +0100
In-Reply-To: <1351523752-4215-5-git-send-email-eranian@google.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-5-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
> +EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x100b,umask=0x1,ldlat=3");
> +EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3"); 

I haven't fully grokked the macro magic yet, but event=0x100b seems
wrong, event only takes 8 bit on Intel.
