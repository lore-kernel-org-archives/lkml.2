Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab2CLXmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:42:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965Ab2CLXlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:41:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH] PM / devfreq: add relation of recommended frequency.
Date: Tue, 13 Mar 2012 00:46:03 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, Mike Turquette <mturquette@ti.com>
References: <201202292359.05122.rjw@sisk.pl> <201203102251.10364.rjw@sisk.pl> <CAJ0PZbSXzkvkOjWw66k5ZrtksQxiF0HwcFZ4jHKs9=4XodszVg@mail.gmail.com>
In-Reply-To: <CAJ0PZbSXzkvkOjWw66k5ZrtksQxiF0HwcFZ4jHKs9=4XodszVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130046.03838.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 12, 2012, MyungJoo Ham wrote:
> 2012/3/11 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, March 07, 2012, MyungJoo Ham wrote:
> >> The semantics of "target frequency" given to devfreq driver from
> >> devfreq framework has always been interpretted as "at least" or GLB
> >> (greatest lower bound). However, the framework might want the
> >> device driver to limit its max frequency (LUB: least upper bound),
> >> especially if it is given by thermal framework (it's too hot).
> >>
> >> Thus, the target fuction should have another parameter to express
> >> whether the framework wants GLB or LUB. And, the additional parameter,
> >> "u32 options", does it.
> >>
> >> With the update, devfreq_recommended_opp() is also updated.
> >>
> >> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > This one looks good.
> >
> > Do you want me to take it as a patch, or to pull it from your tree?
> >
> > Rafael
> 
> Hello Rafael,
> 
> 
> Please pull it from the tree
> (http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next)
> as the change log has been corrected.
> 
> git://git.infradead.org/users/kmpark/linux-samsung devfreq-for-next

I'm not happy with the "PM / devfreq: add PM QoS support" commit, however.

I believe I explained the reason why in a separate message sent a couple of
days ago.

Thanks,
Rafael
