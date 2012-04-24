Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab2DXVCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:02:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55889 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab2DXVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:02:49 -0400
Message-ID: <4F9714F4.2060400@wwwdotorg.org>
Date: Tue, 24 Apr 2012 15:02:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] i2c: Add generic I2C multiplexer using pinctrl API
References: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org> <20120424200929.GC30172@pengutronix.de>
In-Reply-To: <20120424200929.GC30172@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 02:09 PM, Wolfram Sang wrote:
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt
>> @@ -0,0 +1,79 @@
>> +Pinctrl-based I2C Bus Mux
>> +
>> +This binding describes an I2C bus multiplexer that uses pin multiplexing to
>> +route the I2C signals, and represents the pin multiplexing configuration
>> +using the pinctrl device tree bindings.
>> +
>> +Required properties:
>> +- compatible: pinctrl-i2cmux
> 
> From what I know, compatible-properties should not be linux-specific
> since devicetrees are OS independent. pinctrl-i2cmux sounds
> linux-specific to me.
> 
> So, is such a binding acceptable meanwhile?

To my mind, "pinctrl" has two meanings: (1) is the Linux internal API
(2) is the pinctrl bindings in
Documentation/devicetree/bindings/pinctrl, which were admittedly
developed strongly based on Linux's pinctrl API needs, but I believe
should be completely agnostic to the pinctrl API, SW, OS, etc., and
hence can be considered a pure representation of hardware.

As such, the "pinctrl" in "pinctrl-i2cmux" above refers to (2) above,
and can be considered a pure HW/binding term.
