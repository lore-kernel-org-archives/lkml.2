Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab1DARcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:32:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab1DARb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MlqwM0ubKJnoNeh8vO9pILfiLZ+soduk9YweDrizIrd/X/Jv77q/LkIoNA6b4izsMU
         lZxf2q/9+4S3/hKX2aCRy6iyK4dPibEf3UDmbtNui5pKOik6TICWQQEtW+tPGoSCmamk
         QDGtHt5yZLmd2rMt1dT0lCJk7rJmahIAl2Yw0=
MIME-Version: 1.0
In-Reply-To: <4D9603D8.2010709@caviumnetworks.com>
References: <c300b67a7a723369872c0b9a023d0b2e@localhost>
	<4D9603D8.2010709@caviumnetworks.com>
Date: Fri, 1 Apr 2011 10:31:57 -0700
Message-ID: <AANLkTimcCuhtEguCZsVmfAaCDYrGOeJB7+O=EziJ59rR@mail.gmail.com>
Subject: Re: [PATCH v2] MIPS: Kernel crashes on boot with SPARSEMEM + HIGHMEM enabled
From: Kevin Cernekee <cernekee@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: Michael Sundius <msundius@cisco.com>, David VomLehn <dvomlehn@cisco.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andy Whitcroft <apw@shadowen.org>, Jon Fraser <jfraser@broadcom.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 9:56 AM, David Daney <ddaney@caviumnetworks.com> wrote:
> I think this may do the same thing as my patch:
>
> http://patchwork.linux-mips.org/patch/1988/
>
> Although my patch had different motivations, and changes some other things
> around too.

I noticed that some of the other architectures have started using the
<linux/memblock.h> APIs for memory setup.  Do you think this would be
useful on MIPS, as part of a larger refactoring of bootmem_init() ?

What I liked about Michael's fix was that it is simple and
straightforward enough to meet the stable tree criteria.  Long term it
would probably be a good idea to clean up the memory init code and get
rid of the cut&paste "for" loops.
