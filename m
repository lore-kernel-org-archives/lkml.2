Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0LAELK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:11:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:13152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0LAELI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:11:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="682627142"
Date: Wed, 1 Dec 2010 12:11:04 +0800
From: "Li, Yan I" <yan.i.li@intel.com>
To: Tobyn Bertram <tobynbertram@hotmail.com>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "'Takashi Iwai'" <tiwai@suse.de>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <20101201041102.GC3411@thyme.bj.intel.com>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
 <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
 <20101130075026.GA15731@core.coreip.homeip.net>
 <20101130080759.GA17830@thyme.bj.intel.com>
 <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:48:12PM +0800, Tobyn Bertram wrote:
> I do not have a S10-3t.  I have a HP DV7t with a standard 1 button Clickpad.
> I am sorry for any confusion.

Thank you. This clarify the S10-3t touchpad mystery. So I think my v2
patch is valid.

> I think that 2 different Clickpads will need to be defined: 1 button
> Clickpads and 2 button Clickpads.  Maybe like this?
> 
> #define SYN_CAP_CLICKPAD1BTN(ex0c)		((ex0c) & 0x100000)
> #define SYN_CAP_CLICKPAD2BTN(ex0c)		((ex0c) & 0x000100)

Maybe, although we don't have any code that needs
SYN_CAP_CLICKPAD2BTN() so far, only 1-button clickpad needs special
handling, but it's good to have a more precise name.

-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
