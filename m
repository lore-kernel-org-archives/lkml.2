Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1I2TAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:00:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1I2TAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:00:45 -0400
Date: Thu, 29 Sep 2011 11:55:22 -0700
From: Greg KH <gregkh@suse.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
Message-ID: <20110929185522.GA8183@suse.de>
References: <20110928220225.GA27128@kroah.com>
 <20110928220139.453112165@clark.kroah.org>
 <82951087A1ED9648A152812B736362500A8F294274@sausexmbp02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82951087A1ED9648A152812B736362500A8F294274@sausexmbp02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 09:31:47PM -0500, Deucher, Alexander wrote:
> Please don't apply this to stable.  The patch ended up being in error.

Was it also reverted upstream?

I'll go drop it now, thanks.

greg k-h
