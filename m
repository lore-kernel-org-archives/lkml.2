Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1HRHmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:42:36 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:47551 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1HRHmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:42:35 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: gaowanlong@cn.fujitsu.com, Daniel Kurtz <djkurtz@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 5/6] Input: elantech - clean up elantech_init
In-Reply-To: <20110818060038.GA10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw> <CAGS+omDVn1uoU85pPN+jeHMTMp83EA13b3E8Sca0QOqDBZHQFg@mail.gmail.com> <4E4C8218.8040100@cn.fujitsu.com> <87aab746ys.fsf@emc.com.tw> <20110818060038.GA10093@core.coreip.homeip.net>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 15:44:46 +0800
Message-ID: <87ty9f2mfl.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 17 Aug 2011 23:00:38 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Aug 18, 2011 at 01:35:55PM +0800, JJ Ding wrote:
> > Hi Wanlong Gao, Daniel,
> > 
> > On Thu, 18 Aug 2011 11:08:08 +0800, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> > > On 08/18/2011 11:04 AM, Daniel Kurtz wrote:
> > > >
> > > > Assuming paritycheck goes away:
> > > Agree.
> > I thought about removing it, too. But it occured to me that v1 and v2
> > hardware can still have the sysfs entry to turn off parity check.
> > 
> > And since it's exposed in sysfs, I suppose there might be some init
> > scripts relying on it.
> > 
> > What do you think, Dmitry?
> > Shall I remove it?
> 
> No, we should not remove it, since it is useful for V1 hardware which we
> still support.
> 
> How confident are we in the V2/V3 checking not tripping on valid packets?
> 
> Thanks.
With V2 it should work reasonbaly well. Although I don't have test data,
I didn't encounter any problem turning paritycheck off when testing V2.

With V3 we use the check to distinguish first 2-finger packet and the
second one. So it's mandatory with V3.

Thanks
jj
> -- 
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
