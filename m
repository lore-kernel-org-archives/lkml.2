Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2KEJo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:44:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2KEJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:44:56 -0500
Date: Mon, 5 Nov 2012 10:44:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile build
 warning
Message-ID: <20121105094450.GA5220@gmail.com>
References: <20121103224832.GA24262@gmail.com>
 <1352024091.1434.17.camel@x61.thuisdomein>
 <20121104105332.GC27124@gmail.com>
 <20121104.123013.700345271120279281.davem@davemloft.net>
 <20121105084419.GC2699@gmail.com>
 <1352106704.1434.25.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352106704.1434.25.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012, Paul Bolle wrote:

> On Mon, 2012-11-05 at 09:44 +0100, Lee Jones wrote:
> > On Sun, 04 Nov 2012, David Miller wrote:
> > > I think the most appropriate thing to do is make CONFIG_ISDN depend
> > > upon CONFIG_NETDEVICES in the Kconfig file.
> > 
> > ... and then remove the CONFIG_NETDEVICES guards in isdn_common.c?
> 
> If ISDN would depend on NETDEVICES, ISDN_I4L would too, since it depends
> on ISDN. In that case CONFIG_NETDEVICES would always be true when
> compiling isdn_common.c. That would make these guards pointless. (The
> dependency of ISDN_PPP on NETDEVICES would then also be pointless.)

I'll submit a patch based on your comments.

Thanks for your time Paul.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
