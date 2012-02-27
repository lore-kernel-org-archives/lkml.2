Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2B0Gww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:52:52 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61004 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab2B0Gwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:52:50 -0500
X-IronPort-AV: E=Sophos;i="4.73,489,1325458800"; 
   d="scan'208";a="146156594"
Date: Mon, 27 Feb 2012 07:52:47 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] edac: move const pci_device_id tables from __devinitdata
 to __devinitconst.
In-Reply-To: <20120227061300.GC4763@mwanda>
Message-ID: <alpine.DEB.2.02.1202270751550.1871@hadrien>
References: <791782.71473.bm@smtp128.mail.ukl.yahoo.com> <20120227061300.GC4763@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Feb 2012, Dan Carpenter wrote:

> On Sun, Feb 26, 2012 at 09:15:29PM +0100, Lionel Debroux wrote:
>> Based on PaX and earlier work by Andi Kleen.
>>
>> Patch against current Linus tree.
>>
>
> Always write patches against linux-next.  We can't apply this.
>
> I wonder if we could make a coccinelle script for this.

It should be possible at some point - at the moment it rases some parsing 
problems.

I wonder if it would be nicer to always use PCI_VEND_DEV?

julia


>
> regards,
> dan carpenter
>
