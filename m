Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0JKELA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:11:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39677
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab0JKEK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:10:58 -0400
Date: Sun, 10 Oct 2010 21:11:20 -0700 (PDT)
Message-Id: <20101010.211120.189701946.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: dilinger@queued.net, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sparc: make drivers/of/pdt.c no longer sparc-only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101011041010.GB23588@angua.secretlab.ca>
References: <20101010014358.30cb74b5@debxo>
	<20101011041010.GB23588@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 10 Oct 2010 22:10:10 -0600

> On Sun, Oct 10, 2010 at 01:43:58AM -0700, Andres Salomon wrote:
>> 
>> Clean up pdt.c:
>>  - make build dependent upon config OF_PROMTREE
>>  - #ifdef out the sparc-specific stuff
>>  - create pdt-specific header
>> 
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Applied, thanks.  Since the difference between this version and the
> last is trivial, I've carried over davem's acked-by lines on the first
> 3 patches.
> 
> Dave, let me know if you've got any issues with this and I'll drop
> them from my tree.

No problems.
