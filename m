Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2DWR51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:57:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37690 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2DWR50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:57:26 -0400
Date: Mon, 23 Apr 2012 12:57:15 -0500
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
Message-ID: <20120423175715.GD9635@burratino>
References: <1330532667.11248.153.camel@twins>
 <1330534998.11248.158.camel@twins>
 <4F551ABE.5080605@nasza-klasa.pl>
 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
 <1330989903.11248.261.camel@twins>
 <1330990360.11248.264.camel@twins>
 <1330990413.11248.265.camel@twins>
 <4F8D678C.6050104@nasza-klasa.pl>
 <20120417153032.GB21534@burratino>
 <4F958141.2000505@nasza-klasa.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4F958141.2000505@nasza-klasa.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lesław Kopeć wrote:

> 2.6.32.55-hz-0f004f5a69			9.88
> 2.6.32.55-no-hz-74f5187ac8		2.48
> 2.6.32.55-no-hz-c308b56b53		2.22
> 3.0.28-hz				10.66
> 3.0.28-no-hz				0.60
> 3.0.28-no-hz-c308b56b53			4.09
> 3.0.28-no-hz-c308b56b53 nohz=off	6.78
> 3.2.12-hz				10.16
> 3.2.12-no-hz				0.66
> 3.2.12-no-hz-c308b56b53			4.36
>
> What's worth noting is that I haven't seen any nasty side effects of the
> latest patch on all kernel versions that I've tested. Hope that helps.

Ok.

Peter, do you think it would make sense to add c308b56b53987 to 3.0.y
and newer stable kernels?

Thanks,
Jonathan
