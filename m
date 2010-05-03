Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab0ECUoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:44:14 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:38968 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab0ECUoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qQnwo8FL6Wt4culq0jNaNxyXIiGjrJyxr0TNhXuhO8BEeGjFQ15UdbjN7J+zMhDqF5
         4DFmSaIFh6ya0z6iUskUQXQkNYA+Sgm9THKrmYAzX7aHfmM98f/5UQPHKFFfSmL5Babe
         CcWlfqZKGaNUzRVA0Li3zlYvTIbMl/2laAMM0=
MIME-Version: 1.0
In-Reply-To: <1272847591.30040.15.camel@Joe-Laptop.home>
References: <1272847591.30040.15.camel@Joe-Laptop.home>
Date: Mon, 3 May 2010 13:43:01 -0700
X-Google-Sender-Auth: 2607a0d91f5724e1
Message-ID: <m2z9929d2391005031343yab3aa87amc3811252493dcddb@mail.gmail.com>
Subject: Re: [PATCH] ixgb and e1000: Use new function for copybreak tests
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       Alex Duyck <alexander.h.duyck@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 2, 2010 at 17:46, Joe Perches <joe@perches.com> wrote:
> There appears to be an off-by-1 defect in the maximum packet size
> copied when copybreak is speified in these modules.
>
> The copybreak module params are specified as:
> "Maximum size of packet that is copied to a new buffer on receive"
>
> The tests are changed from "< copybreak" to "<= copybreak"
> and moved into new static functions for readability.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/e1000/e1000_main.c |   47 ++++++++++++++++++++---------------
>  drivers/net/ixgb/ixgb_main.c   |   52 +++++++++++++++++++++++----------------
>  2 files changed, 58 insertions(+), 41 deletions(-)
>

Thanks Joe, I have added the patch to my queue of patches.

-- 
Cheers,
Jeff
