Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1HJOaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:30:55 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:49186 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780Ab1HJOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:30:54 -0400
Subject: Re: [PATCH 2/6] staging: vme: make [alloc|free]_consistent bridge
 specific
From: Joe Perches <joe@perches.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E428DC3.5070302@ge.com>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
	 <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>
	 <1312981940.11924.68.camel@Joe-Laptop>  <4E4288CB.7080708@ge.com>
	 <1312984261.11924.91.camel@Joe-Laptop>  <4E428DC3.5070302@ge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 07:30:52 -0700
Message-ID: <1312986652.11924.94.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 14:55 +0100, Martyn Welch wrote:
> On 10/08/11 14:51, Joe Perches wrote:
> > On Wed, 2011-08-10 at 14:34 +0100, Martyn Welch wrote:
> >> On 10/08/11 14:12, Joe Perches wrote:
> >>> Except for the name, those 2 blocks are identical.
> >>> Maybe create a non-pci generic version instead?
> >> I'm not sure you can (I spent quite a bit of time attempting to do just that
> >> when I wrote the original).
> > Doesn't something like this work?
[]
> Could. Though we'd have to put this in a new common file for use by
> vme_tsi148.c and vme_ca91cx42.c as the point of this was to get it out of the
> VME core code. I'm just not sure that it's worth it.

That's a bit different than what you wrote earlier.
No worries then.

cheers, Joe


