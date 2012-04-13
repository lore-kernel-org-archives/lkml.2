Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258Ab2DMLHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:07:00 -0400
Received: from smtp-out-152.synserver.de ([212.40.185.152]:1066 "EHLO
	smtp-out-147.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935198Ab2DMLG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:06:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6328
Message-ID: <4F880960.8010803@metafoo.de>
Date: Fri, 13 Apr 2012 13:09:20 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 0/2] i2c/of: Populate multiplexed i2c busses from the
 device tree.
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 11:14 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> v3: Integrate changes from Lars-Peter Clausen to make better use of
>     the of_*() infrastructure.  Get rid of ugly #ifdefs.
> 
> v2: Update bindings to use "reg" insutead of "cell-index"
> 
> v1: Unchanged from the original RFC where I said:
> 
>   We need to populate our I2C devices from the device tree, but some
>   of our systems have multiplexers which currently break this process.
> 
>   The basic idea is to have the generic i2c-mux framework propagate
>   the device_node for the child bus into the corresponding
>   i2c_adapter, and then call of_i2c_register_devices().  This means
>   that the device tree bindings for *all* i2c muxes must have some
>   common properties.  I try to document these in mux.txt.
> 
> This is now tested against 3.4-rc2 and is still working well.
> 

I've been using these patches with a pca9548 and a pca9546 for a while now.
Both:

Tested-by: Lars-Peter Clausen <lars@metafoo.de>

