Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2EBLO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:14:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2EBLO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:14:56 -0400
Message-ID: <1335957283.13683.180.camel@twins>
Subject: Re: [PATCH v2] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 13:14:43 +0200
In-Reply-To: <20120502103309.GP18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <20120502103309.GP18810@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 12:33 +0200, Robert Richter wrote:
> Updated version. Level 1 and 2 are handled the same way now. Don't
> drop samples in precise level 2 if rip is invalid, instead support the
> PERF_EFLAGS_EXACT flag.
> 
> No changes in other patches of
> 
>  [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs

Thanks!, I managed to stomp all patches on top of -tip and shall be
trying it out on my aging opteron-1216.


