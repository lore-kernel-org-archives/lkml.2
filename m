Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1DAGWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1DAGWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:22:44 -0400
Date: Fri, 1 Apr 2011 02:21:37 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.39 & -stable] x86 intel power: Initialize
 MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20110401062137.GA13327@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <alpine.LFD.2.02.1104010156570.2797@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104010156570.2797@x980>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 01:59:01AM -0400, Len Brown wrote:
 
 > +#define ENERGY_PERF_BIAS_POWERSWAVE	15

Typo I assume.

	Dave

