Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2IDUul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab2IDUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:50:39 -0400
Date: Tue, 4 Sep 2012 16:50:26 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shuah Khan <shuahkhan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Message-ID: <20120904205025.GB2018@zod.bos.redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-11-git-send-email-mjg@redhat.com>
 <CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
 <20120904163829.GA23777@srcf.ucam.org>
 <CAKocOOOMevXWCPgAddo4scC+GY+emw67XxC3vFnOtJM81QxkTA@mail.gmail.com>
 <20120904213742.0221543e@pyramind.ukuu.org.uk>
 <20120904203732.GA29508@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904203732.GA29508@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 09:37:32PM +0100, Matthew Garrett wrote:
> On Tue, Sep 04, 2012 at 09:37:42PM +0100, Alan Cox wrote:
> > > Gotta say this capability name is confusing. Naming is
> > > CAP_PRE_SECURE_BOOT or something along the lines might be a better
> > > choice. When I just look at this name, I sure thought this
> > > CAP_SECURE_FIRMWARE true means it is a secure boot capable firmware.
> > 
> > Given there is nothing secure about it would it also be better to call it
> > AUTHENTICATED_BOOT ?
> 
> Well, there is the question of whether the sense is correct - you'll 
> only have this capability if you don't boot with any form of 
> authentication. CAP_KERNEL_ACCESS?

I'm fine with whatever name we come up with, but I'd like to avoid
bikeshedding it in every patch.  Maybe we could work on the naming
through comments to the patch that actually adds the capability?

josh
