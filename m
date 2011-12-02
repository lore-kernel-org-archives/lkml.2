Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1LBWaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:30:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45807 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1LBWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:30:19 -0500
Message-ID: <1322864926.21423.184.camel@work-vm>
Subject: Re: System freezes with high network activity
From: john stultz <johnstul@us.ibm.com>
To: Jose Luis Salas <josacar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>
Date: Fri, 02 Dec 2011 14:28:46 -0800
In-Reply-To: <CAJPugqs6wDcEM-5p5vRxHNVZd92ozgk0sw7g3=F6pvYyCA-CEw@mail.gmail.com>
References: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com>
	 <1322855029.21423.170.camel@work-vm>
	 <CAJPugqs6wDcEM-5p5vRxHNVZd92ozgk0sw7g3=F6pvYyCA-CEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120222-7282-0000-0000-000004A0F005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 21:54 +0100, Jose Luis Salas wrote:
> Hi,
> 
> attached is the dmesg without the clocksource option.

Thanks. After your done testing nohz=off, could you also
send /proc/timer_list output from the system with no clocksource option,
and no nohz options?


> the nohz=off *seems* to avoid the problem, I'm testing with NFS and Iperf now.

Sounds good. Let us know how the testing goes.

thanks
-john


