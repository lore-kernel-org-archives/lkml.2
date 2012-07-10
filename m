Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2GJTfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:35:41 -0400
Received: from antcom.de ([188.40.178.216]:54226 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2GJTfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:35:40 -0400
Message-ID: <4FFC8408.2040206@antcom.de>
Date: Tue, 10 Jul 2012 21:35:36 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v8] input: keyboard: Add keys driver for the LPC32xx SoC
References: <1340834596-15642-1-git-send-email-stigge@antcom.de> <20120710063657.GC29257@core.coreip.homeip.net> <4FFBF799.9080609@antcom.de> <20120710164123.GA31438@core.coreip.homeip.net>
In-Reply-To: <20120710164123.GA31438@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 10/07/12 18:41, Dmitry Torokhov wrote:
> Ah, right, I meant to change that too ;)
> 
> Could you please try this one for me (instead of the previous one)?

Same problem (you actually sent the same patch).

I'm posting an updated version considering all your suggestions from
your last mail. Works fine now.

Feel free to build upon this if you insist on fancy reformatting. ;-)

Thanks,

Roland
