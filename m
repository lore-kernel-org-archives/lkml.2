Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2DWRMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:12:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35821 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab2DWRMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:12:03 -0400
Message-ID: <4F958D5E.9090003@wwwdotorg.org>
Date: Mon, 23 Apr 2012 11:11:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 2/2] i2c/of: Automatically populate i2c mux busses
 from device tree data.
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com> <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 03:14 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> For 'normal' i2c bus drivers, we can call of_i2c_register_devices()
> and have the device tree framework automatically populate the bus with
> the devices specified in the device tree.
> 
> This patch adds a common code to the i2c mux framework to have the mux
> sub-busses be populated by the of_i2c_register_devices() too.  If the
> mux device has an of_node, we populate the sub-bus' of_node so that
> the subsequent call to of_i2c_register_devices() will find the
> corresponding devices.
> 
> It seemed better to put this logic in i2c_add_mux_adapter() rather
> than the individual mux drivers, as they will all probably want to do
> the same thing.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
