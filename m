Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1LGDpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:45:55 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57389 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1LGDpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:45:54 -0500
Message-ID: <4EDEE15F.2000107@linux.vnet.ibm.com>
Date: Wed, 07 Dec 2011 09:15:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Woody Suwalski <terraluna977@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Belisko Marek <marek.belisko@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
References: <4ED56C12.1040708@gmail.com>	<4ED5C047.6040500@linux.vnet.ibm.com> <20111130062502.68d9db59@tlielax.poochiereds.net> <201112062233.50317.rjw@sisk.pl> <20111206163810.24663e3f@tlielax.poochiereds.net>
In-Reply-To: <20111206163810.24663e3f@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120703-5816-0000-0000-000000578A08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 03:08 AM, Jeff Layton wrote:

> On Tue, 6 Dec 2011 22:33:50 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
>> On Wednesday, November 30, 2011, Jeff Layton wrote:
>>> On Wed, 30 Nov 2011 11:03:59 +0530
>>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>> [...]
>>>
>>> cifs: attempt to freeze while looping on a receive attempt
>>>
>>> In the recent overhaul of the demultiplex thread receive path, we
>>> neglected to ensure that we attempt to freeze on each pass through the
>>> loop.
>>>
>>> Reported-by: Woody Suwalski <terraluna977@gmail.com>
>>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>>
>> I suppose this patch is going to go through the CIFS tree?
>>
> 


Jeff, thanks for the patch and for solving the freezing problem!

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

