Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2EVKGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:06:40 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59388 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab2EVKGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:06:36 -0400
Message-ID: <4FBB6520.10305@mev.co.uk>
Date: Tue, 22 May 2012 11:06:24 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove private header comedi_pci.h
References: <201205211712.12753.hartleys@visionengravers.com>
In-Reply-To: <201205211712.12753.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-22 01:12, H Hartley Sweeten wrote:
> Remove the private header, comedi_pci.h, by moving the two
> helper functions into divers.c and providing the prototypes
> in comedidev.h.
>
> This allows the comedi_pci_enable/disable helper functions
> to be shared instead of having an inline version in every
> comedi pci driver.

I'm wondering if these functions should be EXPORT_SYMBOL() or 
EXPORT_SYMBOL_GPL() since they were originally inline functions.

Opinions?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
