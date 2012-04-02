Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2DBP4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:56:21 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:52754 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751548Ab2DBP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:56:20 -0400
Date: Mon, 2 Apr 2012 11:56:06 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: Linux 3.3-rc2
Message-ID: <20120402155605.GA3155@elliptictech.com>
References: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
 <20120201175651.GA3300@elliptictech.com>
 <20120202033524.GA11360@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202033524.GA11360@localhost>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-02 11:35 +0800, Wu Fengguang wrote:
> Nick,
> 
> [snip]
> > However, the _very next commit_:
> > 
> >   2deed761188d ("drm/i915: HDMI hot remove notification to audio driver")
> > 
> > reintroduces the log spam every mode change, with two additional lines
> > printed each time (the lines prefixed with an asterisk are new):
> > 
> > * HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=1
> > * HDMI status: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=0
> >   HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
> >   HDMI status: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
> >   HDMI: detected monitor W2253 at connection type HDMI
> >   HDMI: available speakers: FL/FR
> >   HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24
> 
> Actually we have another patch to disable all the above printk lines:
> 
> alsa: hide HDMI/ELD printks unless in debug kernels
> http://lists.freedesktop.org/archives/intel-gfx/2011-November/013322.html
> 
> And the plan is to merge it in the next release of all the ELD fixes,
> which should be 3.4.

Ping?

3.4-rc1 is out and my logs are still being filled with this noise :(

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

