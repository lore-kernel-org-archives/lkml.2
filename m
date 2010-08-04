Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab0HDUPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:15:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934556Ab0HDUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,317,1278313200"; 
   d="scan'208";a="644710056"
Message-ID: <4C59CA37.4050509@linux.intel.com>
Date: Wed, 04 Aug 2010 13:14:47 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what
 c_ident is
References: <646233.80914.qm@web27008.mail.ukl.yahoo.com>
In-Reply-To: <646233.80914.qm@web27008.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:12 AM, bifferos wrote:
> 
> I couldn't reproduce this with 2.6.35 (without Peter's change),
> I was trying on VirtualBox.  If the detection code is causing a 
> problem we can just skip it if the CPU has cpuid.
> 
> Incidentally if you need some hardware to test the RDC port on I can
> arrange that.
> 

Incidentally, please do note that there is no concrete benefit to this
"support", since all it does is replicate information in /proc/cpuinfo
that is already available through lspci.

	-hpa
