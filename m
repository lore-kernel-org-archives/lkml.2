Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592Ab0HGKXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 06:23:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0HGKXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 06:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinebiC=9Xd-D_sOwmvA8w_YPWMdhTYz2NRbZ7jH@mail.gmail.com>
References: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com>
	<Pine.LNX.4.44L0.1008061505070.9303-100000@netrider.rowland.org>
	<AANLkTinS_UyhRNMnViK_4aA4ve3thHhLthC+OM7cUMZc@mail.gmail.com>
	<201008071044.37486.rjw@sisk.pl>
	<AANLkTinebiC=9Xd-D_sOwmvA8w_YPWMdhTYz2NRbZ7jH@mail.gmail.com>
Date: Sat, 7 Aug 2010 03:23:32 -0700
Message-ID: <AANLkTim-a6qHL_Xo+iVUW4p79EMMRssa0-AqZenNSYJr@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/7 Arve Hjønnevåg <arve@android.com>:
> 2010/8/7 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
>>> 2010/8/6 Alan Stern <stern@rowland.harvard.edu>:
>>> > On Thu, 5 Aug 2010, Arve Hjønnevåg wrote:
...
>>> >> total_time, total time the wake lock has been active. This one should
>>> >> be obvious.
>>> >
>>> > Also easily added.
>>> >
>>> Only with a handle passed to all the calls.
>>
>> Well, I'm kind of tired of this "my solution is the only acceptable one"
>> mindset.  IMHO, it's totally counter productive.
>>
>
> How do you propose to track how long a driver has blocked suspend when
> you have an unblock call that takes no arguments.
>

Also, I did not not see a response to my question about why you don't
want to pass a handle.

-- 
Arve Hjønnevåg
