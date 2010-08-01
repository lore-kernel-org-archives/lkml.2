Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0HAIIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:08:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53386 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0HAIIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <20100801.010501.27813939.davem@davemloft.net>
References: <20100801074831.1099.3318.stgit@angua> <20100801.010501.27813939.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 1 Aug 2010 02:08:10 -0600
X-Google-Sender-Auth: cQJ2U2KHsFKLwoMF6GM42jELnW0
Message-ID: <AANLkTinkfaDt5HWDby8W1gnms6VZ7DQcpTGu=0AUnx1B@mail.gmail.com>
Subject: Re: [PATCH] of/device: Replace struct of_device with struct 
	of_platform
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 2:05 AM, David Miller <davem@davemloft.net> wrote:
>
> Subject should say "struct platform_device" not "struct of_platform",
> I think :-)

Gah!  yup, will fix.  Thanks.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
