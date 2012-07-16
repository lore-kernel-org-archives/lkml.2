Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2GPNoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:44:20 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44165 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2GPNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:44:14 -0400
Message-ID: <50041A4A.2000206@linux.vnet.ibm.com>
Date: Mon, 16 Jul 2012 19:12:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: regression 918227bb -> -rc7: does not wake up from sleep
References: <20120716132705.GC21748@gamma.logic.tuwien.ac.at>
In-Reply-To: <20120716132705.GC21748@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071613-2674-0000-0000-000005446FBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 06:57 PM, Norbert Preining wrote:
> Hi everyone,
> 
> (please cc)
> 
> I recently upgraded from git918227bb to rc7 and suddenly my laptop
> does not wake up from sleep again, all dead.
> 
> I will try to bisect as soon as possible, but I am on a conference
> and give two talks, so not so much time.
> 
> Is the above problem known? intel graphics card.
> 

Not sure if this is the same problem, but here is a discussion around
a recent commit that broke resume. May be you can try out that patch?

https://lkml.org/lkml/2012/7/16/113
 
Regards,
Srivatsa S. Bhat

