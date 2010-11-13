Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0KMWoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:44:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0KMWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IFF2z8LCi20LH1vllCIyvMkxVZmfNKr8FstUOR3YvZoI9clbE/9br/F34B7kMlZspL
         Z7ETi7GbyBDkzmpy0gbC01/5/dyxXfaLCr4OqGvAeB4ytDDHq9xeVJDvhFJKwsfYLHYf
         YifXxXhW0wVUfgG34TGV8xwoQQMXoXhjaqDIc=
MIME-Version: 1.0
In-Reply-To: <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com> <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Sat, 13 Nov 2010 16:43:30 -0600
Message-ID: <AANLkTi=1nutREorMFY2VJyUYQD0SHfiSeskw-u22P+R-@mail.gmail.com>
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 5:56 AM, Kumar Gala <galak@kernel.crashing.org> wrote:

> Is there any reason we shouldn't set DMA_BIT_MASK(64) since the DMA block programming model allows the address to be 64-bits?

Can you explain that?  The DMA registers only have room for 36 bits
for the physical address.

-- 
Timur Tabi
Linux kernel developer at Freescale
