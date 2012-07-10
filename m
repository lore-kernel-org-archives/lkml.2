Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2GJH4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:56:13 -0400
Received: from antcom.de ([188.40.178.216]:51797 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2GJH4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:56:11 -0400
Message-ID: <4FFBE018.9060108@antcom.de>
Date: Tue, 10 Jul 2012 09:56:08 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] pwm: add lpc32xx pwm support
References: <1341862074-9240-1-git-send-email-aletes.xgr@gmail.com> <20120710064853.GA28840@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120710064853.GA28840@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/10/2012 08:48 AM, Thierry Reding wrote:
>> --- /dev/null +++
>> b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt @@ -0,0
>> +1,12 @@ +LPC32XX PWM controller + +Required properties: +-
>> compatible: should be "nxp,lpc3220-pwm"
> 
> Does the compatible have to be lpc3220-pwm? Can't it be lpc32xx-pwm
> to match the driver and binding names?

When creating the other NXP LPC compatible strings, we agreed on
taking the first LPC32xx chip, i.e., lpc3220, as prefix. (There are 4
of them, -20, -30, -40, -50, most of them supporting things available
in lpc3220.)

So lpc3220-pwm looks good here.

Thanks also for the review. Will have a second look when Alexandre
posts an update.

Thank you two!

Roland
