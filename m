Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2F1Uvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:51:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:51376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F1Uvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:51:49 -0400
Message-ID: <1340916697.28750.91.camel@twins>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>
Date: Thu, 28 Jun 2012 22:51:37 +0200
In-Reply-To: <20120628182030.GR4152@tassilo.jf.intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1340899974.28750.66.camel@twins>
	 <20120628182030.GR4152@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 11:20 -0700, Andi Kleen wrote:
> > Not without a useful userspace part. 
> 
> http://permalink.gmane.org/gmane.linux.kernel/1319962
> 
> > Preferably not a script.
> 
> You don't need to prefer it.

+# will be very time consuming (about 10+ minutes for 10000 samples) if the

Muhahaha... I'll wait for something useful.
