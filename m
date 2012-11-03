Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673Ab2KCA6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:58:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59074 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab2KCA6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:58:37 -0400
Date: Fri, 2 Nov 2012 20:58:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915: failure to interoperate with HP ZR30w using
 an X230
Message-ID: <20121103005831.GA3978@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <nsxa9v4ssgz.fsf@closure.thunk.org>
 <87hapcqu97.fsf@intel.com>
 <87zk34gok8.fsf@intel.com>
 <20121030203221.GA4537@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030203221.GA4537@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Tue, Oct 30, 2012 at 04:32:21PM -0400, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 01:57:27PM +0200, Jani Nikula wrote:
> > > [1] drm-intel-next-queued branch at git://people.freedesktop.org/~danvet/drm-intel
> > 
> > Hmm, actually not. Either drm-intel-fixes branch, or Linus' master.
> 
> Confirmed, the drm-intel-fixes branch from Daniel's tree
> (3.7.0-rc2-00031-g1623392) works fine for me.
> 
> Do you know which commit(s) are likely to have fixed the problem, so we
> can cherry pick the appropriate fix(es) to the 3.6.x tree?
> 
> Thanks,
> 
> 					- Ted
