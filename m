Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0CWN1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:27:42 -0400
Received: from isilmar.linta.de ([213.133.102.198]:55099 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753337Ab0CWN1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:27:40 -0400
Date: Tue, 23 Mar 2010 14:27:37 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       davej@redhat.com, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Message-ID: <20100323132737.GA8894@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Borislav Petkov <bp@amd64.org>, Thomas Renninger <trenn@suse.de>,
	akpm@linux-foundation.org, davej@redhat.com,
	cpufreq@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-3-git-send-email-bp@amd64.org> <201003231217.16451.trenn@suse.de> <20100323115858.GC16493@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323115858.GC16493@aftab>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Mar 23, 2010 at 12:58:58PM +0100, Borislav Petkov wrote:
> > It could already be set in arch/x86/kernel/cpu/amd.c and
> > powernow-k8 could use cpu_has(cpu, X86_FEATURE_CPB);
> 
> I'd still like to cache the cpb_capable value locally instead of getting
> x86_cpuinfo percpu var and querying it. Especially if this happens often
> and not only at driver init.

If it's a percpu var, isn't it local anyway?

Best,
	Dominik
