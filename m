Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2ERIDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:03:31 -0400
Received: from antcom.de ([188.40.178.216]:59167 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab2ERID1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:03:27 -0400
Message-ID: <4FB6024A.5010002@antcom.de>
Date: Fri, 18 May 2012 10:03:22 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: glikely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
Subject: Re: [PATCH RESEND v9 1/2] gpio: Adjust of_xlate API to support multiple
 GPIO chips
References: <1337200832-26630-1-git-send-email-stigge@antcom.de> <20120517203706.6B8223E0621@localhost>
In-Reply-To: <20120517203706.6B8223E0621@localhost>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 05/17/2012 10:37 PM, Grant Likely wrote:
> On Wed, 16 May 2012 22:40:31 +0200, Roland Stigge <stigge@antcom.de> wrote:
>> This patch changes the of_xlate API to make it possible to manipulate the
>> actual used gc. This way, multiple GPIO banks can be supported with the same DT
>> registered GPIO controller.
>>
>> The issue was discussed upon the integration of LPC32xx's DT support for its
>> GPIO (see separate patch).
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> I still wasn't happy with this approach, so I bugged Arnd and we
> discussed some options.  So, I think I've got a better solution that
> doesn't change the signature of of_xlate.  Instead it allows of_xlate
> to return an error code and still have multiple banks referring to the
> same gpio_chip.
> 
> I've just posted the series.  Can you try it out and make sure it
> works for you?

Works fine, just consider the little compile error bugfix, see next mail.

Thanks,

Roland
