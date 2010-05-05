Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab0EEHzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:55:16 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:48272 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0EEHzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:55:13 -0400
Message-ID: <4BE1245F.801@msgid.tls.msk.ru>
Date: Wed, 05 May 2010 11:55:11 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100306 Icedove/3.0.3
MIME-Version: 1.0
To: Stefan Weinhuber <wein@linux.vnet.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       Stefan Weinhuber <wein@de.ibm.com>,
       Horst Hummel <Horst.Hummel@de.ibm.com>,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: deadline ALWAYS default for dasd devices(s390) ?
References: <4BD58848.8090205@gmail.com> <20100505061620.GA2381@osiris.boeblingen.de.ibm.com> <4BE123B1.1050500@linux.vnet.ibm.com>
In-Reply-To: <4BE123B1.1050500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.05.2010 11:52, Stefan Weinhuber wrote:
>> On Mon, Apr 26, 2010 at 02:34:16PM +0200, Xose Vazquez Perez wrote:
>>> hi,
>>>
>>> why is it FORCED ? bypassing a GLOBAL setting and also the kernel
>>> command line !!!
>
> At the time this change was made we had the problem that the
> default scheduler chosen by the distributions resulted in
> bad performance for DASD devices.
> I don't know what options were considered back then, but
> I think that having the device driver set a driver specific default
> is better than forcing the whole system to use 'our' scheduler.
>
> I agree that hard coding this choice into the driver is not pretty,
> but it is pragmatic. Some generic mechanism for setting driver specific
> defaults would be nicer, but I doubt that many other drivers would
> actually benefit from such an interface.

See also another thread started just two days ago:

  http://lkml.org/lkml/2010/5/3/404

Just... one more data point... ;)

/mjt
