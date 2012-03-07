Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2CGLxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:53:35 -0500
Received: from antcom.de ([188.40.178.216]:59299 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab2CGLxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:53:34 -0500
Message-ID: <4F574C38.4030006@antcom.de>
Date: Wed, 07 Mar 2012 12:53:28 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, baruch@tkos.co.il,
        joe@perches.com
Subject: Re: [PATCH v5] lpc32xx: Added ethernet driver
References: <1331067664-9124-1-git-send-email-stigge@antcom.de> <201203062134.38077.arnd@arndb.de>
In-Reply-To: <201203062134.38077.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 03/06/2012 10:34 PM, Arnd Bergmann wrote:
> This should eventually both become run-time options based on the device tree.
> I don't know if you planned to do that anyway, but if you want the same kernel
> binary to be used for systems in different configurations, you cannot have
> compile-time decisions that are exclusive-or. Since you don't support device
> tree yet but plan to do that in the future, you could add a comment here
> about it, or you could even prepare it for that case already by passing the
> device into the functions that will be required for reading the properties.

Good point.

I prefer putting a comment for now, because upon the planned device tree
introduction in lpc32xx, an internal change in lpc_eth.c will be
necessary anyway, so there is no need to already introduce unused
parameters at this point.

Thanks,

Roland
