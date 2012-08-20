Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2HTM6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:58:20 -0400
Received: from antcom.de ([188.40.178.216]:48997 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2HTM6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:58:17 -0400
Message-ID: <50323464.4070006@antcom.de>
Date: Mon, 20 Aug 2012 14:58:12 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH RESEND v4] spi/pl022: add devicetree support
References: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 08/20/2012 01:39 PM, Alexandre Pereira da Silva wrote:
> Add the chipselect array and cur_cs properties to pl022 main structure
>
> Add a wrapper function to decide if the cs should be controlled by the
> cs_control callback or the chipselect gpio
>
> Populate chipselect property from cs-gpios
>
> Populate master->dev.of_node, so the spi bus can find child spi
> devices and register them
>
> At pl022 setup, fill chip_data structure from dt nodes, if not provided
> by platform.
>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Acked-by: Roland Stigge <stigge@antcom.de>

We somehow missed 3.6 with this one. Would be nice to have it in 3.7 now
since it's useful for mach-lpc32xx when it's available.

If there are any open issues, I can assist Alexandre on this patch.

Thanks in advance,

Roland
