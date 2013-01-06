Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3AFJ4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:56:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38007 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3AFJ4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:56:41 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
Thread-Topic: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
Thread-Index: Ac3YcO0CDWQUo8AuS62wk1akhW9wsQElCMwAAILAn5AC1itxgABif42w
Date: Sun, 6 Jan 2013 09:56:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1168A@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E0AAA1@DQHE02.ent.ti.com>
 <CAK5ve-KcCbgcHSRiMX0t3vxXNk=BOXBVm=e820K=KLs5nGRzBg@mail.gmail.com>
 <A874F61F95741C4A9BA573A70FE3998F69E107F3@DQHE02.ent.ti.com>
 <CAK5ve-K_U8Gs4Mp=BVurpV_SyUTM+iTW9Pt227M4mUpcu+xzhg@mail.gmail.com>
In-Reply-To: <CAK5ve-K_U8Gs4Mp=BVurpV_SyUTM+iTW9Pt227M4mUpcu+xzhg@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bryan Wu [mailto:cooloney@gmail.com]
> Sent: Saturday, January 05, 2013 3:46 AM
> To: Kim, Milo
> Cc: linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
> 
> On Thu, Dec 20, 2012 at 4:17 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> >> Hi Kim
> >>
> >> This patchset looks good, but I need some time to review it more
> >> carefully especially during this merge window + holiday time.
> >
> > OK, thanks for the reply.
> > Please let me know if any problem in the git tree.
> > Happy holidays!
> >
> 
> Hi Milo,
> 
> Since we got several updates in our leds.git for-next branch, could
> you please update your patch on top of my latest for-next branch? And
> publish it somewhere, I can pull it cleanly.

Hi Bryan,

New git place is here. You can pull them from the location below.

 git://github.com/milokim/lp55xx.git lp55xx-for-next

This branch is based on latest 'for-next' branch of linux-leds.
And same patches have been sent to linux-leds mailing list.

Many thanks!
Milo
