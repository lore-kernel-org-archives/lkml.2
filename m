Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1DDKkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:40:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63365 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1DDKkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V1n3RKwCIKjDdIRZdN/S2Tc1ECmCIMesV6d1teMWr3pZipF0aAAGNtyBibT9zHmJDn
         bXs0W5+sQX9gXXtVCxzQjtNdpVvH+B4fO2I56l3fmqOGpzhpJmPWhcut9N28K5WgbRix
         4Ye4gdrSj7QNWv/qYYpT5R+PlCy8Hj7DTaWv0=
Date: Mon, 4 Apr 2011 14:40:06 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110404104006.GA24789@oksana.dev.rtsoft.ru>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru>
 <20110403140750.GB5670@pulham.picochip.com>
 <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
 <20110403152244.GC5670@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110403152244.GC5670@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 04:22:44PM +0100, Jamie Iles wrote:
[...]
> > As discussed earlier in the thread, you probably don't need to support
> > multiple banks with this driver.  Instead, create a separate device
> > instance for each bank.
> 
> The reason I proposed this was for controllers where the registers 
> aren't grouped together for each bank.  For example, the Synopsys block 
> has:
> 
> 	0x00-0x08 bank A control registers
> 	0x0c-0x14 bank B control registers
> 	...
> 	0x50	  bank A input register
> 	0x54	  bank B input register.

Which, I guess, is another point for "multiple resources" approach.
Grant?

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
