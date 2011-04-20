Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1DTP67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:58:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51070 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DTP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:58:58 -0400
Date: Wed, 20 Apr 2011 17:58:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: rwhitton@iee.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
Message-ID: <20110420155853.GB2312@gere.osrc.amd.com>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
 <20110420154658.GD1624@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420154658.GD1624@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 05:46:58PM +0200, Markus Trippelsdorf wrote:
> BTW is it really necessary to print the following to syslog:
> 
> EDAC amd64: pci-read, sdram scrub control value: 15
> EDAC MC: Read scrub rate: 97650
> 
> everytime one runs:
>  # cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> 97650
> 
> ?

This is KERN_DEBUG since .38 (commit 24f9a7fe3f19f3fd310f556364d01a22911724b3)
and it shouldn't appear on the console if you don't change your default log level.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
