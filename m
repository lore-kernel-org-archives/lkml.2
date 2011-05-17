Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1EQHGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:06:14 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:45088 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752859Ab1EQHGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:06:11 -0400
Message-ID: <4DD21E5E.9000605@armadeus.com>
Date: Tue, 17 May 2011 09:06:06 +0200
From: Fabien Marteau <fabien.marteau@armadeus.com>
Reply-To: fabien.marteau@armadeus.com
Organization: ARMadeus Systems
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog
 to Digital Converter.
References: <fabien.marteau@armadeus.com> <1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com> <20110516153900.GA31255@ericsson.com>
In-Reply-To: <20110516153900.GA31255@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2188186470692512176
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500001/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Thanks for the review.

On 16/05/2011 17:39, Guenter Roeck wrote:
> On Mon, May 16, 2011 at 09:39:14AM -0400, fabien.marteau@armadeus.com wrote:
>> From: Fabien Marteau <fabien.marteau@armadeus.com>
>>
>>
> Some description, such as "Dhis driver adds support for xxx" would be nice.
> 
> Also, I wonder if this driver belongs into hwmon in the first place. It is
> a generic ADC chip with high conversion rate. iio would probably be more
> appropriate and also much better in supporting high speed readings.
I provided this driver "as is" because it's a driver that work well on
our platform. I thought that iio was not stable enough driver framework
to be used.
I can rewrite it under iio framework but I have no time for this moment
to do that. You think it's better to wait for an iio driver or to
continue commiting this ?

regards,
Fabien M
