Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2EYOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:34:50 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30046 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808Ab2EYOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:34:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: o9qWe0IVM1lMW5Dyvr.gMsB_pnmA.X0oLZBQfGKjOikFEDe
 de7PGtAUKg0zzsGeb4ZJfGmXoOGkykLrNwkFnWD13BTKy3kwRkRSLk6AhdxA
 l_n3pfrFrItfQMfZ8thAnaPNucf_a9FBcb1ZkMVv42n1SXmGAEmZU68A5qdI
 qudi1sBqBITJEXvXd79AIIBGi6Mzh3LA9mpBWYrHlJl0NLMUlba5g92PFFSh
 iR39EJA7MNsXCt2dRz9zl4aylSCX2Y.UTSJckUop02b8BKTHgJ6dbZjRNCYX
 9XGu1ejy3.sl.YLn9lSFNqlT2DOIz6BxKF18RL4Q4X9BgHdfBJsvbkqnYgzV
 tRYeOrYPVarW0nmS6QaEc0_gaYL0Dq5PAghTwb2kNM0pc2cWmnibCC5QxzBI
 c
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 25 May 2012 09:34:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Michal Hocko <mhocko@suse.cz>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
In-Reply-To: <20120525133441.GB30527@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1205250933170.22597@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Michal Hocko wrote:

> On Fri 25-05-12 17:03:20, Glauber Costa wrote:
> > I believe some of the early patches here are already in some trees around.
> > I don't know who should pick this, so if everyone agrees with what's in here,
> > please just ack them and tell me which tree I should aim for (-mm? Hocko's?)
> > and I'll rebase it.
>
> memcg-devel tree is only to make development easier. Everything that
> applies on top of this tree should be applicable to both -mm and
> linux-next.
> So the patches should go via traditional Andrew's channel.

It would be best to merge these with my patchset to extract common code
from the allocators. The modifications of individual slab allocators would
then be not necessary anymore and it would save us a lot of work.

