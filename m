Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab0EEHwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:52:22 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:54085 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab0EEHwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:52:20 -0400
Message-ID: <4BE123B1.1050500@linux.vnet.ibm.com>
Date: Wed, 05 May 2010 09:52:17 +0200
From: Stefan Weinhuber <wein@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
       Stefan Weinhuber <wein@de.ibm.com>,
       Horst Hummel <Horst.Hummel@de.ibm.com>,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: deadline ALWAYS default for dasd devices(s390) ?
References: <4BD58848.8090205@gmail.com> <20100505061620.GA2381@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100505061620.GA2381@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Mon, Apr 26, 2010 at 02:34:16PM +0200, Xose Vazquez Perez wrote:
>> hi,
>>
>> why is it FORCED ? bypassing a GLOBAL setting and also the kernel command line !!!
>>
> 
> Horst, Stefan W. or Stefan H. should be able to answer your question.

At the time this change was made we had the problem that the
default scheduler chosen by the distributions resulted in
bad performance for DASD devices.
I don't know what options were considered back then, but
I think that having the device driver set a driver specific default
is better than forcing the whole system to use 'our' scheduler.

I agree that hard coding this choice into the driver is not pretty,
but it is pragmatic. Some generic mechanism for setting driver specific 
defaults would be nicer, but I doubt that many other drivers would 
actually benefit from such an interface.


