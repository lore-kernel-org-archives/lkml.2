Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0CXKc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0CXKc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:32:28 -0400
Message-ID: <4BA9EA5C.9060506@redhat.com>
Date: Wed, 24 Mar 2010 11:33:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for F71808E
 and F71889
References: <20100323141718.GA23172@salidar.me.mortis.eu> <1269385936-3440-1-git-send-email-me@mortis.eu> <1269385936-3440-2-git-send-email-me@mortis.eu> <1269385936-3440-3-git-send-email-me@mortis.eu> <1269385936-3440-4-git-send-email-me@mortis.eu> <4BA9CF57.4030504@redhat.com> <20100324093651.GG6368@salidar.me.mortis.eu>
In-Reply-To: <20100324093651.GG6368@salidar.me.mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/24/2010 10:36 AM, Giel van Schijndel wrote:
> On Wed, Mar 24, 2010 at 09:37:43AM +0100, Hans de Goede wrote:
>> Nack:
>> As the watchdog has its own SIO logical device number, it should
>> have a separate driver, not have support glued to the hwmon driver.
>
> Thus, if I understand correctly, you would suggest for me to implement a
> new driver in drivers/watchdog/ to implement this driver?
>

Yes, correct.

Regards,

Hans
