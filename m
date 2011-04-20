Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1DTQpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:45:09 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:40977 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1DTQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:45:08 -0400
Date: Wed, 20 Apr 2011 18:45:06 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: rwhitton@iee.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
Message-ID: <20110420164506.GE1624@x4.trippels.de>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
 <20110420154658.GD1624@x4.trippels.de>
 <20110420155853.GB2312@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420155853.GB2312@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.20 at 17:58 +0200, Borislav Petkov wrote:
> On Wed, Apr 20, 2011 at 05:46:58PM +0200, Markus Trippelsdorf wrote:
> > BTW is it really necessary to print the following to syslog:
> > 
> > EDAC amd64: pci-read, sdram scrub control value: 15
> > EDAC MC: Read scrub rate: 97650
> > 
> > everytime one runs:
> >  # cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> > 97650
> > 
> > ?
> 
> This is KERN_DEBUG since .38 (commit 24f9a7fe3f19f3fd310f556364d01a22911724b3)
> and it shouldn't appear on the console if you don't change your default log level.

Yes. Sorry, but I was referring to dmesg and not the console. 
What I mean is that maybe debugf1 or debugf2 is more appropriate than
amd64_debug?

-- 
Markus
