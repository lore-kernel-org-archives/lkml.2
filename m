Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2JBQ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:59:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50894 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2JBQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:59:44 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <alpine.DEB.2.02.1210021725320.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210021725320.29232@kaball.uk.xensource.com>
Date: Tue, 2 Oct 2012 09:59:42 -0700
Message-ID: <CAOesGMjy2icwKduijghZ=cq-EMSWewEL+E1mUNySuxngXpHzCA@mail.gmail.com>
Subject: Re: make dtbs in linus/master
From: Olof Johansson <olof@lixom.net>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:36 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> Hello,
> I am testing linus/master after the recent merge with the arm-soc tree
> and I find that if I choose:
>
> ARM system type
>   1. Allow multiple platforms to be selected (ARCH_MULTIPLATFORM) (NEW)
>   2. ARM Ltd. Integrator family (ARCH_INTEGRATOR)
>   3. ARM Ltd. RealView family (ARCH_REALVIEW)
>>  4. ARM Ltd. Versatile family (ARCH_VERSATILE)
>
> in my kernel config, then "make dtbs" doesn't work.
> However if I choose ARCH_MULTIPLATFORM then it works properly.
>
> Is it expected?

Yes, because versatile does not list any device tree files to build in
the makefile (arch/arm/boot/dts/Makefile)


-Olof
