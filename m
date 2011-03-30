Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1C3SgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:36:09 -0400
Received: from us-mx4.synaptics.com ([12.178.49.178]:48386 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1C3SgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:36:07 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 30 Mar 2011 10:21:09 -0800
Message-ID: <4D937814.5010604@synaptics.com>
Date: Wed, 30 Mar 2011 11:36:04 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <WManson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen Driver
References: <1301446249-13646-1-git-send-email-cheiny@synaptics.com> <1301446249-13646-2-git-send-email-cheiny@synaptics.com> <20110330080223.GB2232@pengutronix.de>
In-Reply-To: <20110330080223.GB2232@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 01:02 AM, Wolfram Sang wrote:
> * PGP Signed by an unknown key: 03/30/2011 at 12:02:23 AM
> Hi,
>
>> +	retval = rmi_register_sensor(&instancedata->rmiphysdrvr, platformdata->perfunctiondata);
>> +	if (retval) {
>> +		dev_err(&client->dev, "%s: Failed to Register %s sensor drivers\n",
>> +				__func__, instancedata->rmiphysdrvr.name);
>> +		i2c_set_clientdata(client, NULL);
>
> I originally just wanted to say that this line can be removed. Then I
> remembered that I already sent a patch for a similar driver in staging
> (dc7b202a4ee6cb686e2bbef80c84443f43ec91bd). The staging driver looks in
> a better shape to me. Do you know about it?

Hi Wolfram,

That call is required in order to register the sensor device on the rmi 
bus, so that the rmi functions can be associated with it.  Without that 
call, the driver will not function.

I'm afraid I can't locate the commit you specified.  I do find a driver 
in staging/ste_rmi4/synaptics_i2c_rmi4.[ch] - is that the one?  If not 
which, tree/branch can I find it in?

					Thanks,
						Chris

