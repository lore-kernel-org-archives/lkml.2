Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0HGVsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:48:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47357 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0HGVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nl8vlannBQvzv791Im6GcU47wJyBoZmSY6hN3ru1taVDWT1yOR6Uf62+K/4D9fgjmU
         Ax35fG7MHRsynv0vD3n0z5wzkyufh3XrQtOQlEwe5/FHBWJ4Wt/8eSgQzUpJcUcKK+OT
         2Vqdqndswz/El33+3A4troZMpRgXPvgpEWb18=
Date: Sun, 8 Aug 2010 01:48:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf,x86: P4 PMU -- update nmi irq statistics and
	unmask lvt entry properly
Message-ID: <20100807214803.GC10428@lenovo>
References: <20100805150917.GA6311@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805150917.GA6311@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:09:17PM +0400, Cyrill Gorcunov wrote:
> In case if last active performance counter is not overflowed at
> moment of NMI being triggered by another counter, the irq statistics
> may miss an update stage. As a more serious consequence -- apic quirk
> may not be triggered so apic lvt entry stay masked.
> 
> Tested-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> ---

Ping? Frederic, perhaps you'll pick it up?

	-- Cyrill
