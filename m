Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1EJNOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:14:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36777 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1EJNOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:14:07 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>, Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 10 May 2011 18:43:45 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwPAKHg8HnHrxDxS6OKavbv7MGyOgAEyMVQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CE6600F@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
 <20110426124519.GC5977@suse.de>
 <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg>
 <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com>
 <0B813DC0439B438BBB2B66A88B1A5F7F@subhasishg>
In-Reply-To: <0B813DC0439B438BBB2B66A88B1A5F7F@subhasishg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 16:24:35, Subhasish Ghosh wrote:
> >> 
> >> >>The driver should probably just get sram
> >> >> space through platform data so that it doesn't depend on the
> >> >> platform specific sram allocation function.
> >> 
> >> Are you suggesting that I go back to that implementation.
> > 
> > No, the platform code should use the SRAM allocator and
> > pass on the allocated memory to the driver.
> > 
> 
> Say, if the driver is loaded as a module.
> If I allocate the sram in the platform code, how to I
> free it when the driver is unloaded. 

This is what I said in my last e-mail. What is
the issue you see with this approach?

| Thanks for the clarification. In this case, the driver
| should use platform callbacks to get/put fast fifo
| space. In case this callback is not populated by the
| platform or returns an error, the driver should fall
| back to allocating from DDR.

Thanks,
Sekhar



