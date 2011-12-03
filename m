Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1LCQpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 11:45:00 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55473 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1LCQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 11:44:57 -0500
Message-ID: <4EDA51FF.8050904@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 22:14:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: 3.2.0-rc4+ (Linus GIT af968e29acd91ebeb4224e899202c46c93171ecd)
 -- Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze,
 wq_busy=0):
References: <CAHFgRy_ae70MZOgY8q3i36NJh42=GK=XP=EA=ktxgXiFzjY49w@mail.gmail.com> <4ED9C7D7.5030300@linux.vnet.ibm.com> <CAHFgRy_o6b9ih=BXysL9Ws6KDcVcOkJ2hnLa9zZJ=m-=zoLmPA@mail.gmail.com>
In-Reply-To: <CAHFgRy_o6b9ih=BXysL9Ws6KDcVcOkJ2hnLa9zZJ=m-=zoLmPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120316-8256-0000-0000-0000005F9BE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 09:07 PM, Miles Lane wrote:

> Thanks!  The patch worked perfectly.
> 
>         Miles
> 


I had written that patch when I found a possibility of freezing failure when
looking at the code. I hadn't really hit the problem myself. (And to test my
patch's effectiveness, I had used a synthetic scenario that I had created.)

So, since you seem to have hit the problem during normal usage itself and not
while doing anything fancy, out of curiosity, what triggered the problem?

Regards,
Srivatsa S. Bhat

