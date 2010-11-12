Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0KLBbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:31:19 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43060 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab0KLBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:31:18 -0500
Date: Fri, 12 Nov 2010 09:41:18 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC PATCH] Make swap accounting default behavior configurable
Message-Id: <20101112094118.b02b669f.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101111093155.GA20630@tiehlicka.suse.cz>
References: <20101110125154.GC5867@tiehlicka.suse.cz>
	<20101111094613.eab2ec0b.nishimura@mxp.nes.nec.co.jp>
	<20101111093155.GA20630@tiehlicka.suse.cz>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 10:31:55 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 11-11-10 09:46:13, Daisuke Nishimura wrote:
> > On Wed, 10 Nov 2010 13:51:54 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > Hi,
> > > could you consider the patch bellow? It basically changes the default
> > > swap accounting behavior (when it is turned on in configuration) to be
> > > configurable as well. 
> > > 
> > > The rationale is described in the patch but in short it makes it much
> > > more easier to enable this feature in distribution kernels as the
> > > functionality can be provided in the general purpose kernel (with the
> > > option disabled) without any drawbacks and interested users can enable
> > > it. This is not possible currently.
> > > 
> > > I am aware that boot command line parameter name change is not ideal but
> > > the original semantic wasn't good enough and I don't like
> > > noswapaccount=yes|no very much. 
> > > 
> > > If we really have to stick to it I can rework the patch to keep the name
> > > and just add the yes|no logic, though. Or we can keep the original one
> > > and add swapaccount paramete which would mean the oposite as the other
> > > one.
> > > 
> > hmm, I agree that current parameter name(noswapaccount) is not desirable
> > for yes|no, but IMHO changing the user interface(iow, making what worked before 
> > unusable) is worse.
> > 
> > Although I'm not sure how many people are using this parameter, I vote for
> > using "noswapaccount[=(yes|no)]".
> 
> Isn't a new swapaccount parameter better than that? I know we don't want
> to have too many parameters but having a something with a clear meaning
> is better IMO (noswapaccount=no doesn't sound very intuitive to me).
> 
Fair enough. It's just an trade-off between compatibility and understandability.

> > And you should update Documentation/kernel-parameters.txt too.
> 
> Yes, I am aware of that and will do that once there is an agreement on
> the patch itself. At this stage, I just wanted to have a feadback about
> the change.
> 
I'll ack your patch when it's been released with documentation update.

Thanks,
Daisuke Nishimura.
