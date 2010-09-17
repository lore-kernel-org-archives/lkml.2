Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0IQRol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:44:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36643 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0IQRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vekhB7lHKxzuK4ZcFQSgkPQ28DADtKXWo/C3YrQMoysPFR76x9g1pJg+cV92+R3WZn
         KCLrWIvYK33026tkHUM59GPvLGATA2xWQfBcR4bf1WW88R7q+A2+i/GFmf6LNvbC7Vfp
         J6+vk1sr0UjuTpp338r/+6XTUs1ySWSmWhePU=
MIME-Version: 1.0
In-Reply-To: <20100917084411.GC20325@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
	<20100915124831.GB27658@esdhcp04044.research.nokia.com>
	<AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com>
	<20100915222216.GF27658@esdhcp04044.research.nokia.com>
	<AANLkTikgi38O3=MsVNc-X64PnLOFNktC_x9Y3vQ7CbD+@mail.gmail.com>
	<20100917084411.GC20325@esdhcp04044.research.nokia.com>
Date: Fri, 17 Sep 2010 10:44:38 -0700
Message-ID: <AANLkTinm6qSOGTzX1J-3R27o5KxGkx8Esg+iCbb3Wnu6@mail.gmail.com>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
From: Tony Luck <tony.luck@gmail.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a shame, but not a real problem in the context of my patch - you can't
> usefully optimise something that's seemingly almost never used. It can be filed
> in the cylindrical filing cabinet.

I'll probably apply it anyway ... it looks like it will be useful when
I get things like this
working.  The initial problem with kmemleak seems to be configuration related. I
cut back from 4096 cpus on 1024 nodes to a more modest 32 cpus on 8 nodes,
and my system boots.  Still can't test your patch because although debugfs got
configured and apparently built-in ok ... I can't see it in
/proc/filesystems, so it
won't mount.

Thanks

-Tony
