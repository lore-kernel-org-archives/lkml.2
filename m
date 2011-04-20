Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1DTPXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:23:43 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:39166 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1DTPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:23:42 -0400
Message-ID: <4DAEF98D.2090802@ladisch.de>
Date: Wed, 20 Apr 2011 17:19:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: rwhitton@iee.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
References: <16117.1303310442@jupiter.eclipse.co.uk>
In-Reply-To: <16117.1303310442@jupiter.eclipse.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Whitton wrote:
> > Robert Whitton wrote:
> > > I have a home grown module that performs background memory scrubbing
> > > to eliminate single bit memory errors before they become a problem.
> > > ... it is specifically targeted at the AMD64 PC architecture
> > 
> > Then why don't you use the memory controller's automatic background
> > memory scrubbing support? Doesn't your BIOS have this option?
> 
> Unfortunately in common with a large number of hardware platforms
> background scrubbing isn't supported in the hardware (even though ECC
> error correction is supported) and thus there is no BIOS option to
> enable it.

Which hardware platform is this?  AFAICT all architectures with ECC
(old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
PCI configuration register 0x58 in function 3 of the CPU's northbridge
device, see the BIOS and Kernel's Developer's Guide for details).


Regards,
Clemens
