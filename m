Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab0E2XAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 19:00:17 -0400
Received: from crca.org.au ([74.207.252.120]:51585 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab0E2XAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 19:00:15 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C019C75.6020000@crca.org.au>
Date: Sun, 30 May 2010 09:00:05 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100529131810.5bb51bdd@schatten.dmk.lab>	<Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org> <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
In-Reply-To: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I like the sound of this much better too, but...

On 30/05/10 08:13, Arve Hjønnevåg wrote:
> On Sat, May 29, 2010 at 7:10 AM, Alan Stern<stern@rowland.harvard.edu>  wrote:
>> There is no /sys/power/policy file.  In place of opportunistic suspend,
>> we have "QoS-based suspend".  This is initiated by userspace writing
>> "qos" to /sys/power/state, and it is very much like suspend-to-RAM.
>
> Why do you want to tie it to a specific state?

I do agree here. I would suggest that all /sys/power/state possibilities 
should have a qos- equivalent. You might not want to use any or all of 
them, but they should be available.

Regards,

Nigel



