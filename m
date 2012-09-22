Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2IVGSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 02:18:34 -0400
Received: from wdmail02.wdc.com ([129.253.55.42]:25127 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2IVGSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 02:18:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,465,1344236400"; 
   d="scan'208";a="6480371"
From: Daniel Taylor <Daniel.Taylor@wdc.com>
To: "'anish singh'" <anish198519851985@gmail.com>
CC: Deepawali Verma <dverma249@gmail.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Work queue questions
Thread-Topic: Work queue questions
Thread-Index: AQHNmB+2EvxSNhADc0u6rFkSYElUlpeViBoAgAALT4CAAAFfgIAADi+AgAAAXgCAAAI0gIAAk/2A//+ZcKCAAIKxAP//jWeQ
Date: Sat, 22 Sep 2012 06:18:33 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
	<CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
 <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
In-Reply-To: <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.44.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...

> >> So on so forth.
> >> Anyway how can you write chunks of data in parallel when
> >> already some worker
> >> thread is writing i.e. the system is busy.
> >> Analogy: Suppose you are ambidextrous and you are eating.Can
> >> you eat with
> >> both of your hands at a time?So worker thread are like your
> >> hands and keeping
> >> you fed all the time is the concept of concurrency.
> >>
> >> I am not an expert on this but from Tejun's reply I could
> >> make out this.
> >> Please correct me If I have wrongly understood the concept
> >> based on this mail
> >
> > I don't know how many cores are in the CPU Deepawali's 
> using, but if I have four,
> Assuming single core,Is my explanation correct about concurrency?

It is possible for his tasks to complete before scheduling occurs
again.  Consuming all of the CPU and having no blocking action,
yes, then the tasks will run consecutively.

...