Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1F1QLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:11:00 -0400
Received: from 8bytes.org ([88.198.83.132]:51577 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758855Ab1F1QKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:10:03 -0400
Date: Tue, 28 Jun 2011 18:10:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
Message-ID: <20110628161000.GF29299@8bytes.org>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:37:29PM +0200, Joerg Roedel wrote:
> this is the second version of the patch-set to support the AMD
> guest-/host only bits in the performance counter MSRs. Due to lack of
> time I havn't looked into emulating support for this feature on Intel or
> other architectures, but the other comments should be worked in. The
> changes to v1 include:
> 
> 	* Rebased patches to v3.0-rc3
> 	* Allow exclude_guest and exclude_host set at the same time
> 	* Reworked event-parse logic for the new exclude-bits
> 	* Only count guest-events per default from perf-kvm

Hi Peter, Ingo,

have you had a chance to look at this patch-set? Are any changes
required?

Regards,
	Joerg

