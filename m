Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0LAHSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:18:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:57264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0LAHSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:18:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631893614"
Date: Wed, 1 Dec 2010 15:18:19 +0800
From: "Li, Yan I" <yan.i.li@intel.com>
To: Tobyn Bertram <tobynbertram@hotmail.com>
Cc: "tiwai@suse.de" <tiwai@suse.de>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <20101201071817.GB3874@thyme.bj.intel.com>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
 <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
 <20101130075026.GA15731@core.coreip.homeip.net>
 <20101130080759.GA17830@thyme.bj.intel.com>
 <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
 <20101201041102.GC3411@thyme.bj.intel.com>
 <s5heia2ni58.wl%tiwai@suse.de>
 <BAY130-W15C8BF6B2994FAE083FAF5DE260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY130-W15C8BF6B2994FAE083FAF5DE260@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 02:41:14PM +0800, Tobyn Bertram wrote:
> The 2-button Clickpad will probably need some code to handle click and drag properly in multi-touch mode.

Talk to a kernel developer and s/he will tell you to implement that
logic in X. :)

In X we already have so much code to handle the complexity and quirks
of 1000 different touchpads in the wild.

-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
