Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab0IGU3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:29:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab0IGU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:29:40 -0400
Date: Tue, 7 Sep 2010 16:29:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [git pull v2] i915
Message-ID: <20100907202934.GA24791@bombadil.infradead.org>
References: <89kc63$i063ms@fmsmga002.fm.intel.com>
 <AANLkTi=pFSB5AfqXbPNUQUknbnCBwqUHdUVzR6jaZqaQ@mail.gmail.com>
 <8u3s94$geldgp@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8u3s94$geldgp@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:55:58AM +0100, Chris Wilson wrote:
> Hi Linus,
> 
> I've gone over the set of patches and removed any that are not a
> regression, hang, compilation or other stability fix. I have left one in
> from Zhenyu that adds new PCI-IDs for Sandybridge.
> 

Hi Chris,

Without reverting ce171780, graphics don't come back after resuming on
my x201s. (drm/i915: Enable RC6 on Ironlake.) Several users bisected
failing graphics on resume to this commit, and I've confirmed that
reverting it does indeed fix the problem.

regards, Kyle.
