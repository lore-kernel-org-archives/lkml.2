Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1EQSRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:17:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37961 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1EQSRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:17:40 -0400
Date: Tue, 17 May 2011 19:17:33 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 1/5] acpi-cpufreq: Add support for modern AMD CPUs
Message-ID: <20110517181733.GA26018@srcf.ucam.org>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
 <20110517173536.GI30053@aftab>
 <20110517174233.GA25111@srcf.ucam.org>
 <20110517181353.GC26422@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517181353.GC26422@gere.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 08:13:53PM +0200, Borislav Petkov wrote:

> Right, but I don't think that would be different on Intel and
> static_cpu_has is faster with the alternatives mechanism anyway.

>From a neatness perspective it might be reasonable to add it like this 
and then just fix both up in one go, but the same argument applies to 
fixing the intel case first and then applying this patchset. So I'm 
happy enough changing that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
