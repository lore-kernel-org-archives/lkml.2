Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2GUXXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 19:23:49 -0400
Received: from void.printf.net ([89.145.121.20]:41832 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2GUXXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 19:23:48 -0400
From: Chris Ball <cjb@laptop.org>
To: "S\, Venkatraman" <svenkatr@ti.com>
Cc: Kevin Hilman <khilman@ti.com>, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Balaji T K <balajitk@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: omap_hsmmc: ensure probe returns error upon resource failure
References: <1341963658-20896-1-git-send-email-khilman@ti.com>
	<CANfBPZ8afVFt8UFr2Bi1M=NYbr_W0oH5ZOy90EXdQ9zaVm63dQ@mail.gmail.com>
Date: Sat, 21 Jul 2012 19:23:35 -0400
In-Reply-To: <CANfBPZ8afVFt8UFr2Bi1M=NYbr_W0oH5ZOy90EXdQ9zaVm63dQ@mail.gmail.com>
	(Venkatraman S.'s message of "Thu, 12 Jul 2012 11:49:13 +0530")
Message-ID: <87k3xw3dhk.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 12 2012, S, Venkatraman wrote:
> On Wed, Jul 11, 2012 at 5:10 AM, Kevin Hilman <khilman@ti.com> wrote:
>> If platform_get_resource_by_name() fails, driver probe is aborted an
>> should return an error so the driver is not bound to the device.
>>
>> However, in the current error path of platform_get_resource_by_name(),
>> probe returns zero since the return value (ret) is not properly set.
>> With a zero return value, the driver core assumes probe was successful
>> and will bind the driver to the device.
>>
>> Fix this by ensuring that probe returns an error code in this failure
>> path.
>>
>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>
> Good catch.
> Acked-by: Venkatraman S <svenkatr@ti.com>

Thanks, pushed to mmc-next for 3.6.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
