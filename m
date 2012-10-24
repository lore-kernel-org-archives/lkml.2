Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161491Ab2JXWjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:39:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49055 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161330Ab2JXWjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:39:07 -0400
Date: Thu, 25 Oct 2012 00:39:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paul Thompson <set.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible
Message-ID: <20121024223904.GA9129@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Paul Thompson <set.mailinglist@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20121024082423.GB2604@squish.home.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121024082423.GB2604@squish.home.loc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:24:23AM -0400, Paul Thompson wrote:
> 	Hi;
> 
> 	Just saw this after invoking cpufreq-set -g performance in
> an attempt to enhance a stuttering mpeg transcode for ps3mediaserver.
> 	This repeats in the logs about 10 times. If anyone cares, I
> will be responsive.
> 
> Paul
> 
> 2012 Oct 24 01:39:14: BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/22941
> 2012 Oct 24 01:39:14: caller is powernowk8_target+0x19/0x50
...

http://marc.info/?l=linux-kernel&m=135111561229153

HTH.

-- 
Regards/Gruss,
    Boris.
