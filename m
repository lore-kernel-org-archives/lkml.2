Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0CSVFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:05:00 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:36882 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752056Ab0CSVE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:04:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kSmKfbUc4hcMvwln7T3XMcH2pY1hUd44m4+emyBFJc1/5ENXTpWOoAaWdBSx133OxdT4fTkpo4yW7DY/OdxxGN4zXtkFnSRrMNy3IJXPMt/VPJsoM/Xjli1Km8uJkEBl;
Date: Fri, 19 Mar 2010 14:05:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
       dri-devel@lists.sourceforge.net,
       Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, yakui.zhao@intel.com, zhenyuw@linux.intel.com,
       Len Brown <lenb@kernel.org>
Subject: Re: ACPI _LID failures
Message-ID: <20100319140503.5ac6e061@jbarnes-piketon>
In-Reply-To: <87iq8sqbih.fsf@pollan.anholt.net>
References: <89k83ahv05c@azsmga001.ch.intel.com>
	<cover.1268680514.git.surbhi.palande@canonical.com>
	<20100319125320.22d8b25d@jbarnes-piketon>
	<87iq8sqbih.fsf@pollan.anholt.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 13:53:10 -0700
Eric Anholt <eric@anholt.net> wrote:

> On Fri, 19 Mar 2010 12:53:20 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Mon, 15 Mar 2010 21:32:41 +0200
> > Surbhi Palande <surbhi.palande@canonical.com> wrote:
> > 
> > > The following two patches are quirks that blacklist bios which report
> > > incorrect lid status. These are bioses for machines with a 900 GM.
> > > The first one is tested by Ubuntu users and the second one isn't.
> > > Further testing will be appreciated.
> > > 
> > > 
> > > Surbhi Palande (2):
> > >   drm/i915: blacklist lid status: Sony VGN-BX196VP
> > >   drm/i915: blacklist lid status: Elite Co. G335
> > > 
> > >  drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
> > >  1 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > Patches look ok to me.  Len was curious about whether some recent ACPI
> > EC fixes will fix some of our lid detection bugs though.
> > 
> > Len, is there any particular patch or version people should try?
> 
> Unless ACPI is going to magically become more reliable at the lid
> method, I think we should abandon using it on generations where it
> fails.  See other patch I submitted -- anyone care to ack it?

Well, that was the hope.  Len said they've fixed EC bugs in the past
only to find that several ACPI methods they assumed were broken
suddenly started working....

-- 
Jesse Barnes, Intel Open Source Technology Center
