Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab2IDUhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:37:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58147 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2IDUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:37:39 -0400
Date: Tue, 4 Sep 2012 21:37:32 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Message-ID: <20120904203732.GA29508@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-11-git-send-email-mjg@redhat.com>
 <CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
 <20120904163829.GA23777@srcf.ucam.org>
 <CAKocOOOMevXWCPgAddo4scC+GY+emw67XxC3vFnOtJM81QxkTA@mail.gmail.com>
 <20120904213742.0221543e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904213742.0221543e@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 09:37:42PM +0100, Alan Cox wrote:
> > Gotta say this capability name is confusing. Naming is
> > CAP_PRE_SECURE_BOOT or something along the lines might be a better
> > choice. When I just look at this name, I sure thought this
> > CAP_SECURE_FIRMWARE true means it is a secure boot capable firmware.
> 
> Given there is nothing secure about it would it also be better to call it
> AUTHENTICATED_BOOT ?

Well, there is the question of whether the sense is correct - you'll 
only have this capability if you don't boot with any form of 
authentication. CAP_KERNEL_ACCESS?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
