Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0HKOUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:20:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35254 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HKOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iN6Ev/jSl8HeGVH+WrivYKR8s3chvGDzACuP4HHdpV8GOts7JAcfQLwW2VujbtuCsf
         x1yy82fUseO6RHuam1DjGr/w1PtdmDVyilfGNczeftqVYexbKiHV/E3JmW2KVKtYIK4Y
         7Cgzt503N1UN5x3g+E0ILdc0BBVFAa28dfRi4=
Date: Wed, 11 Aug 2010 19:49:53 +0530
From: Rabin Vincent <rabin@rab.in>
To: john stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
        arnd.bergmann@de.ibm.com
Subject: Re: [PATCH] arm: fix versatile boot hang (seen with qemu)
Message-ID: <20100811141953.GB5846@debian>
References: <1281493191.2955.42.camel@localhost.localdomain>
 <20100811072014.GA14306@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811072014.GA14306@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 08:20:14AM +0100, Russell King wrote:
> On Tue, Aug 10, 2010 at 07:19:51PM -0700, john stultz wrote:
> > Hey Russell,
> > 
> > 	I have been having troubles getting the 2.6.35 kernel to boot in my
> > qemu-system-arm environment.
> 
> It's a qemu bug.

The fix there, long since applied, is:

http://www.mail-archive.com/qemu-devel@nongnu.org/msg30785.html
