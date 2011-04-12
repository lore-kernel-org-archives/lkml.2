Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1DLUsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:48:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55659 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1DLUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:48:20 -0400
Date: Tue, 12 Apr 2011 21:48:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        nagananda.chumbalkar@hp.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: pcc-cpufreq bug [Was: Bug in cpufreq-utils
 (/sys/devices/system/cpu/cpu*/cpufreq/affected_cpus)?]
Message-ID: <20110412204811.GA9465@srcf.ucam.org>
References: <4D9DEC01020000A1000059B5@gwsmtp1.uni-regensburg.de>
 <20110412203915.GB12827@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412203915.GB12827@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:39:15PM +0200, Dominik Brodowski wrote:

> To the pcc-cpufreq.c driver developers & maintainers: Is there _any_ way to
> properly set
> 
> 	(struct cpufreq_policy *) -> cpus
> 				  -> related_cpus
> 
> in this driver?

The spec says we should be able to do this with the _PSD data. I'll look 
into it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
