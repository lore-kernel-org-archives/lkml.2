Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1GVOtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:49:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39497 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1GVOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:49:08 -0400
Date: Fri, 22 Jul 2011 15:49:04 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110722144904.GA4791@srcf.ucam.org>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com>
 <20110722144143.GA26010@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722144143.GA26010@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 04:41:43PM +0200, Borislav Petkov wrote:

> You need to handle the case where boosting is not even supported by the
> CPU. For example, a Barcelona CPU does not boost but I get
> 
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/boost
> 1

Ah, yeah. Fair enough.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
