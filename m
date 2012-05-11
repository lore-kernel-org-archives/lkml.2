Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2EKChq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:37:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34683 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162Ab2EKCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FAC35E2.4060900@xenotime.net>
References: <20120510192635.c6f3a55196bbf65f13956e44@canb.auug.org.au> <4FAC35E2.4060900@xenotime.net>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 10 May 2012 22:36:55 -0400
X-Google-Sender-Auth: GuHILS5ppBVy7wokfPihKh08M2I
Message-ID: <CAP=VYLon7XRoh9s==wGYjUPNAYaTk8QQx7FGRnaDR97v+O-zXA@mail.gmail.com>
Subject: Re: linux-next: Tree for May 10 (net/phy)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 5:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 05/10/2012 02:26 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120508:
>
>
>
> ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!

Not just randconfig, but also powerpc allmodconfig:

http://kisskb.ellerman.id.au/kisskb/buildresult/6291463/

Adding ppc ML to cc.

P.
--


>
> Full randconfig file is attached.
>
> --
> ~Randy
