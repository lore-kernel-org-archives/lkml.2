Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0LAIB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:01:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:19414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0LAIB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:01:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631902440"
Date: Wed, 1 Dec 2010 16:01:23 +0800
From: "Li, Yan I" <yan.i.li@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tobyn Bertram <tobynbertram@hotmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "'Takashi Iwai'" <tiwai@suse.de>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <20101201080121.GE3874@thyme.bj.intel.com>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
 <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
 <20101130075026.GA15731@core.coreip.homeip.net>
 <20101130080759.GA17830@thyme.bj.intel.com>
 <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
 <20101201041102.GC3411@thyme.bj.intel.com>
 <20101201074649.GC26958@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201074649.GC26958@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 03:46:49PM +0800, Dmitry Torokhov wrote:
> On Wed, Dec 01, 2010 at 12:11:04PM +0800, Li, Yan I wrote:
> > On Tue, Nov 30, 2010 at 11:48:12PM +0800, Tobyn Bertram wrote:
> > > I do not have a S10-3t.  I have a HP DV7t with a standard 1 button Clickpad.
> > > I am sorry for any confusion.
> > 
> > Thank you. This clarify the S10-3t touchpad mystery. So I think my v2
> > patch is valid.
> > 
> 
> Yep, I'll queue it gfor .37.

Thank you. Here we're testing it extensively. Will report if I seen
any new issues.

-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
