Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab1KVLko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:40:44 -0500
Received: from nm37-vm6.bullet.mail.bf1.yahoo.com ([72.30.238.206]:31399 "HELO
	nm37-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756937Ab1KVLkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:40:43 -0500
X-Yahoo-Newman-Id: 129403.75202.bm@smtp207.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8lAZ2J4VM1lI.hqy9JslAJavSQuGxB2D6H1utJTB9diTmGi
 MvAmXqNlDT0kHLYJ4JX2LgFYaWXmms_dgQB9Cx9Q3Xi697kVO6FBmJ3tJhxx
 BjLtnzV6o840wsxryTOXoQROW4ukfguK9wfsfOMt5SLgg5996.sXhFrhmy7R
 ecO5oLOwbEvQR6ArVECqaJi_VrMyuCDz1mH2fcbDqmJvGS3ISYGoQSLfzxD6
 aGMQONAlqz6ywgo1_YPjr79SvjSXpupMNtO_a6HQTmXBlWcV1OfwIEnRYBT.
 QrvvmJngUnf52bT00iryb1qDXx.lxfoNCWhV.YgFAPuNsah1QeydVApeH4wH
 pNX_o89qNRpICsckbIe0YMi9QYGLZqPGh4toB4Abe4Lv7SCSogw--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 22 Nov 2011 06:40:21 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111122114019.GA20081@zeus>
References: <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
 <20111104134347.GA2480@zeus>
 <20111104161431.GZ4417@google.com>
 <20111104173441.GA2157@zeus>
 <CAH3drwaXcUy1vz8bvHwE2_iga5WUsWn_Dp0oe_0r3UacV0vT_A@mail.gmail.com>
 <20111104230758.GA7332@zeus>
 <20111121210908.GJ25776@google.com>
 <CAH3drwbtWJcPOixW0gze0e0jbTn_uY0x5E=KY8N-WDcb1t8h2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3drwbtWJcPOixW0gze0e0jbTn_uY0x5E=KY8N-WDcb1t8h2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 04:29:23PM -0500, Jerome Glisse wrote:
> On Mon, Nov 21, 2011 at 4:09 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Out of curiosity, did it get somewhere?
> >
> > Thanks.
> >
> > --
> > tejun
> >
> 
> Yeah i am pretty sure i know what's going wrong but there is no easy
> fix, there is a deadlock in the kernel when gem wait ioctl is call on
> scanout buffer and that a gpu reset happen
> 
> Cheers,
> Jerome

Tejun, I was about to send a similar email asking about this; many thanks
for sharing my interest.

Jerome, sounds encouraging that you think you know what the issue is. What
are the next steps? Please let me know how I can assist on my end (code 
validation, etc.).

~ Andy

