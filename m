Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0IUVYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:24:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41409 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab0IUVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Re3DDsyXj/Ed9w0HWBsK/X00CugbgjSZRuZSwXgmm6LUWkXJwELtSHMuE6NzX98HrM
         Eu/gdzeCtDY+vG3l58CyDzIM/a9Vfj8vvtpYfB0vbBZl8n8ilgacaht9i8vfrZom/EBU
         3Jfn9PipkrmXAm5epUUAkHayAE2R22KiANL1E=
MIME-Version: 1.0
In-Reply-To: <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com> <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Tue, 21 Sep 2010 16:24:10 -0500
Message-ID: <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 7:55 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Sep 21, 2010, at 5:57 AM, Li Yang wrote:
>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> ---
>
> We really should have a sentence about how or why this works to address 36-bit addressing.

For example, I would like to know which memory is going to be
allocated above 4GB.  I don't know much about the kernel's async
library, but my understanding is that fsldma does not allocate any of
the memory buffers that it copies data to/from.  The only memory that
fsldma allocates is for the DMA descriptors, which are very small and
probably don't take up more than a couple pages.

-- 
Timur Tabi
Linux kernel developer at Freescale
