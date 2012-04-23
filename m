Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2DWUVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:21:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:60488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab2DWUVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:21:10 -0400
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>,
        Aman Gupta <aman@tmm1.net>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20120423175715.GD9635@burratino>
References: <1330532667.11248.153.camel@twins>
	 <1330534998.11248.158.camel@twins> <4F551ABE.5080605@nasza-klasa.pl>
	 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
	 <1330989903.11248.261.camel@twins> <1330990360.11248.264.camel@twins>
	 <1330990413.11248.265.camel@twins> <4F8D678C.6050104@nasza-klasa.pl>
	 <20120417153032.GB21534@burratino> <4F958141.2000505@nasza-klasa.pl>
	 <20120423175715.GD9635@burratino>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 22:21:06 +0200
Message-ID: <1335212466.2463.85.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 12:57 -0500, Jonathan Nieder wrote:
> Lesław Kopeć wrote:
> 
> > 2.6.32.55-hz-0f004f5a69			9.88
> > 2.6.32.55-no-hz-74f5187ac8		2.48
> > 2.6.32.55-no-hz-c308b56b53		2.22
> > 3.0.28-hz				10.66
> > 3.0.28-no-hz				0.60
> > 3.0.28-no-hz-c308b56b53			4.09
> > 3.0.28-no-hz-c308b56b53 nohz=off	6.78
> > 3.2.12-hz				10.16
> > 3.2.12-no-hz				0.66
> > 3.2.12-no-hz-c308b56b53			4.36
> >
> > What's worth noting is that I haven't seen any nasty side effects of the
> > latest patch on all kernel versions that I've tested. Hope that helps.
> 
> Ok.
> 
> Peter, do you think it would make sense to add c308b56b53987 to 3.0.y
> and newer stable kernels?

If anybody is still maintaining those and cares enough to do the work,
sure whatever.. ;)

