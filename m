Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab0GBRKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:10:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44025 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0GBRK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=cZgQSzf7m1L+wZDnYUuvt76MyqXVPLj6Suj3d4rkcwZ7MfyXh8fRtU214mEwBzScKg
         hX5A9QEY7psKeV5ouKgL8PAGTkku64xhicArQ2WaSc4ClsTpQM/NMAmn//oNqsc70hXW
         diBEUBW5eivC1aPgb3w2Pz7qZGhqm/ELrHG4U=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for July 2 (touchscreen/ad7879)
Date: Fri, 2 Jul 2010 09:58:03 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Michael Hennerich <hennerich@blackfin.uclinux.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20100702163505.272e6fca.sfr@canb.auug.org.au> <20100702093944.b0ebe49a.randy.dunlap@oracle.com>
In-Reply-To: <20100702093944.b0ebe49a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007020958.05448.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 02, 2010 09:39:44 am Randy Dunlap wrote:
> On Fri, 2 Jul 2010 16:35:05 +1000 Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20100630:
> > 
> > The tip tree lost a conflict.
> > 
> > The driver-core tree gained a conflict agains the jdelvare-hwmon tree.
> > 
> > -------------------------------------------------------------------------
> > ---
> 
> drivers/input/touchscreen/ad7879.c: In function 'ad7879_probe':
> drivers/input/touchscreen/ad7879.c:487: error: 'struct ad7879' has no
> member named 'mutex' drivers/input/touchscreen/ad7879.c:578: warning:
> passing argument 1 of 'ad7879_gpio_add' from incompatible pointer type
> drivers/input/touchscreen/ad7879.c:444: note: expected 'struct device *'
> but argument is of type 'struct ad7879 *'
> drivers/input/touchscreen/ad7879.c:578: error: too many arguments to
> function 'ad7879_gpio_add' drivers/input/touchscreen/ad7879.c:589:
> warning: passing argument 1 of 'ad7879_gpio_remove' from incompatible
> pointer type drivers/input/touchscreen/ad7879.c:449: note: expected
> 'struct device *' but argument is of type 'struct ad7879 *'
> drivers/input/touchscreen/ad7879.c: In function 'ad7879_remove':
> drivers/input/touchscreen/ad7879.c:604: warning: passing argument 1 of
> 'ad7879_gpio_remove' from incompatible pointer type
> drivers/input/touchscreen/ad7879.c:449: note: expected 'struct device *'
> but argument is of type 'struct ad7879 *'
> 
> 
> config file is attached.
> 

Oops, I will fix that up.

Thanks for the report Randy.

-- 
Dmitry
