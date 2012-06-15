Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2FOTEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:04:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2FOTEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:04:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
Date: Fri, 15 Jun 2012 21:09:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Cong Wang <amwang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai.lu@oracle.com>
References: <1339478463-31172-1-git-send-email-amwang@redhat.com> <CAM_iQpUq39+VQMU6rq78iqpy2m-PnSwWUW4M3WYjpecVVv4jhw@mail.gmail.com> <s5h8vfoojns.wl%tiwai@suse.de>
In-Reply-To: <s5h8vfoojns.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206152109.55091.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 15, 2012, Takashi Iwai wrote:
> At Fri, 15 Jun 2012 19:11:12 +0800,
> Cong Wang wrote:
> > 
> > On Tue, Jun 12, 2012 at 1:21 PM, Cong Wang <amwang@redhat.com> wrote:
> > >
> > > Takashi, could you help to test if the S4 regression is still
> > > there after this patch?
> > 
> > Hello,
> > 
> > Any comments?
> > 
> > I have tested this revert on my laptop, with running simple
> > "suspend and resume" test for several times, I didn't see any
> > problem.
> 
> Sorry for the late response.
> 
> The problem happens only on certain laptops.  I've tested the recent
> IvyBridge laptops and these were OK with the reverted patch.  But a
> SandyBridge laptop, the one I tested in the last year, still hits the
> S4 problem with the reverted kernel.
> 
> But, the recent kernels seem to have other S4 problems on this
> machine, so it's not 100% clear whether it's triggered by that.
> At least, it jumpts to the boot at S4 resume more frequently when the
> patch is reverted.
> 
> So, I need to start from 2.6.32 again to see what regressions have
> been introduced.  It'll take time, since I'd have to S4 20 cycles
> for reproducing the bug.

Thanks for doing this, please let me know if there's any way I can help.

Rafael
