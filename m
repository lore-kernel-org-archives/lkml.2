Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab1JFPZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:25:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1JFPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:25:14 -0400
Date: Thu, 6 Oct 2011 17:25:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, andi@firstfloor.org,
        robert.richter@amd.com, ravitillo@lbl.gov
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken branches
Message-ID: <20111006152508.GI14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks very nice patchkit (at least from the description,
haven't read it yet)

> # Overhead  Source Symbol     Target Symbol
> # ........  ................  ................
> 
>     18.13%  [.] f1            [.] main                          
>     18.10%  [.] main          [.] main                          
>     18.01%  [.] main          [.] f1                            

The big problem here is no line numbers (something I miss for other analysis
too).  I hope that can be fixed so that analysis inside functions becomes
possible. Something similar to pprofs line mode.

-Andi
