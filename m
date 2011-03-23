Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1CWK3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:29:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab1CWK3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:29:12 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] cpupowerutils - cpufrequtils extended with quite some features
Date: Wed, 23 Mar 2011 11:29:09 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-desktop; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, linux@dominikbrodowski.net,
        Len Brown <lenb@kernel.org>, herrmann.der.user@googlemail.com
References: <201103111247.00212.trenn@suse.de>
In-Reply-To: <201103111247.00212.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231129.10249.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, hi Len,

it would be great to get this tool pulled into:
tools/power/cpupower

All that is needed should be to push (old git history should better
be left out):
wget http://gitorious.org/cpupowerutils/cpupowerutils/archive-
tarball/cpupowerutils cpupowerutils.tar.gz
into tools/power/cpupower
and add to MAINTAINERS file:

CPU POWER MONITORING SUBSYSTEM
M:      Dominik Brodowski <linux@dominikbrodowski.net>
M:      Thomas Renninger <trenn@suse.de>
S:      Maintained
F:      tools/power/cpupower

Could this still show up in 2.6.39?

Thanks,

    Thomas



On Friday, March 11, 2011 12:46:59 PM Thomas Renninger wrote:
> Hi,
> 
...
> What is this tool doing?
> ------------------------
> 
> It provides all features cpufrequtils does.
> It got enhanced with cpuidle and turbo/boost mode (on X86) statistics.
> On AMD the exact amount of supported boost states and their frequencies
> are shown. On Intel only turbo/boost support is shown.
> 
> It got enhanced with a generic HW monitor tool (cpupower monitor).
...
> 
> What next?
> ----------
> 
> After some testing phase it would be great to get this tool
> merged into the kernel git repo under:
> tools/power/cpupower
