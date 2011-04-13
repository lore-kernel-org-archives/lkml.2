Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1DMVxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:53:39 -0400
Received: from mail.digium.com ([216.207.245.2]:47176 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab1DMVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:53:38 -0400
Date: Wed, 13 Apr 2011 16:53:22 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Don Zickus <dzickus@redhat.com>, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
	proper MSR register to catch" and NMIs
Message-ID: <20110413215322.GA11670@digium.com>
References: <20110406223036.GA15721@digium.com> <201104132133.51958.maciej.rutecki@gmail.com> <4DA6011F.7070405@openvz.org> <20110413203501.GA10744@digium.com> <4DA60B03.30603@openvz.org> <20110413212208.GJ16939@redhat.com> <4DA614DF.5090304@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA614DF.5090304@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 01:25:51AM +0400, Cyrill Gorcunov wrote:
...
> OK, thanks for review! Shaun please continue testing it, if all will be fine until tomorrow
> we will ask Ingo to pick it up then. Sounds OK for everyone?

Sounds good. I'll let it run tonight with v2 tonight.
