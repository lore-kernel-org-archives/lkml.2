Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2DQPao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:30:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64043 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2DQPam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:30:42 -0400
Date: Tue, 17 Apr 2012 10:30:32 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, Aman Gupta <aman@tmm1.net>,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inconsistent load average on tickless kernels
Message-ID: <20120417153032.GB21534@burratino>
References: <4F465F6E.9070605@nasza-klasa.pl>
 <1330517195.11248.148.camel@twins>
 <1330532667.11248.153.camel@twins>
 <1330534998.11248.158.camel@twins>
 <4F551ABE.5080605@nasza-klasa.pl>
 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
 <1330989903.11248.261.camel@twins>
 <1330990360.11248.264.camel@twins>
 <1330990413.11248.265.camel@twins>
 <4F8D678C.6050104@nasza-klasa.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4F8D678C.6050104@nasza-klasa.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lesław Kopeć wrote:

> I've finally finished testing patch c308b56b53. Apologies for the delay
> in reporting back. This time I've compared kernels from 3.2 and 2.6.32
> branches. Here's a snapshot of load 15 on different versions:
[...]
> Just to make things clear 2.6.32 kernels were patched as follows:
> * 74f5187ac8 - just 74f5187ac8
> * 0f004f5a69 - 74f5187ac8 + 0f004f5a69
> * c308b56b53 - 74f5187ac8 + 0f004f5a69 + c308b56b53
>
> For kernel 3.2.12 patch c308b56b53 seems almost perfect. For low CPU
> utilization the load value is slightly lower for NO_HZ version than it
> is for HZ one. However the difference is small and the overall trend
> relates to CPU usage quite closely.

Nice.

[...]
> Looking at results for 2.6.32.55 branch it seems that we're back at
> 74f5187ac8 patch - the values are almost the same. The difference
> between NO_HZ and HZ versions is noticeable.

How does 3.0.y + c308b56b53 do?  (I ask because the usual flow of
fixes is mainline -> 3.3.y -> 3.2.y -> 3.0.y -> 2.6.32.y with the
first three steps happening pretty quickly, so it we can get this
working on 3.0.y then that would be progress.  Also because, like
2.6.32.y, 3.0.y is longterm maintained, so it might be useful in the
meantime.)

Curious,
Jonathan
