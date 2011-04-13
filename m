Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1DMKzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:55:19 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48390 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155Ab1DMKzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:55:17 -0400
Date: Wed, 13 Apr 2011 12:55:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        nagananda.chumbalkar@hp.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: pcc-cpufreq bug [Was: Bug in cpufreq-utils
	(/sys/devices/system/cpu/cpu*/cpufreq/affected_cpus)?]
Message-ID: <20110413105515.GA14864@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
	nagananda.chumbalkar@hp.com, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <4D9DEC01020000A1000059B5@gwsmtp1.uni-regensburg.de> <20110412203915.GB12827@comet.dominikbrodowski.net> <20110412204811.GA9465@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412204811.GA9465@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 09:48:11PM +0100, Matthew Garrett wrote:
> On Tue, Apr 12, 2011 at 10:39:15PM +0200, Dominik Brodowski wrote:
> 
> > To the pcc-cpufreq.c driver developers & maintainers: Is there _any_ way to
> > properly set
> > 
> > 	(struct cpufreq_policy *) -> cpus
> > 				  -> related_cpus
> > 
> > in this driver?
> 
> The spec says we should be able to do this with the _PSD data. I'll look 
> into it.

Thanks!

	Dominik
