Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2CMNfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:35:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57511 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2CMNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:35:05 -0400
Date: Tue, 13 Mar 2012 13:34:59 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
Message-ID: <20120313133458.GA11574@srcf.ucam.org>
References: <1331608337.2267.67.camel@debian.Gayathri>
 <20120312175130.GA18002@srcf.ucam.org>
 <1331640592.3485.50.camel@debian.Gayathri>
 <20120313124738.GB10822@srcf.ucam.org>
 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 06:56:16PM +0530, Pradeep Subrahmanion wrote:
> I tried giving acpi_backlight = vendor . In that case hot key for
> brightness control is working. But i think  , it is not calculating the
> correct value for brightness because increasing brightness after maximum
> level gives blank screen .

Which backlight device appears then?

> By ' ACPI interface' , I mean 'acpi_video0' inside the
> /sys/class/backlight. I havn't tried the /sys/class/backlight interface
> directly . I will try that also.

So writing values into /sys/class/backlight/acpi_video0/brightness does 
nothing?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
