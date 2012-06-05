Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2FEO7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:59:42 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:22056 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2FEO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:59:40 -0400
Message-ID: <1338908377.2977.1.camel@lorien2>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, Fabio Baltieri <fabio.baltieri@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Tue, 05 Jun 2012 08:59:37 -0600
In-Reply-To: <CAK5ve-Km=+M2nDyadV3zNcJxUoHJi=qRS7zbNrS=EGF=6uHQNg@mail.gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
	 <1338135226.2968.22.camel@lorien2> <20120531210800.GB2400@gmail.com>
	 <1338565180.2618.9.camel@lorien2> <20120604213735.GA1858@gmail.com>
	 <1338851529.16672.1.camel@lorien2>
	 <CAK5ve-Km=+M2nDyadV3zNcJxUoHJi=qRS7zbNrS=EGF=6uHQNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 11:05 +0800, Bryan Wu wrote:
> On Tue, Jun 5, 2012 at 7:12 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> >
> >>
> >> Of course, I've made many tests with mixes of led_trigger_blink() and
> >> led_trigger_blink_oneshot() calls, and they seems to work samelessly.
> > Great.
> >>
> >> If you think that the patch is good I'd like to consider that for
> >> integration, so I can repost a modified version of my can-trigger
> >> patch on the linux-can mailing list.
> >
> > Sounds good to me.
> >
> 
> Hi Fabio,
> 
> I'm going to apply the patch to my for-next branch. and Shuah, can I
> add your ack to this patch?

Bryan,

Yes. You can add my ack to this patch.

Thanks,
-- Shuah

