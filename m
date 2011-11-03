Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1KCNQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:16:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1KCNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:16:45 -0400
Date: Thu, 3 Nov 2011 06:15:38 -0700
From: Greg KH <gregkh@suse.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [028/107] drm/radeon/kms: fix typo in r100_blit_copy
Message-ID: <20111103131538.GA8444@suse.de>
References: <20111102221600.GA26650@kroah.com>
 <20111102221452.655563086@clark.kroah.org>
 <A3397C8B8B789E45844E7EC5DEAD89D00AFCA478@sausexdag02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D00AFCA478@sausexdag02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 01:01:35PM +0000, Deucher, Alexander wrote:
> Please don't apply.  This ended up getting reverted upstream.

Ah, thanks, I forgot to remove it here when I also removed it from the
3.0 tree.

greg k-h
