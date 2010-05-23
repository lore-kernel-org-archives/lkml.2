Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0EWOD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 10:03:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59664 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0EWODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 10:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IlVyIdWsQp47sGq7zE/53XsyBenuUBM/rjZOo3DjpGENjSMLoTVGc8sO2JMJAoDgb3
         Ae2TqXJ+LZs2PghDzMMDsGTp2XKGGNut4PXSF80yfjt5hbQi6rsOrE6cXrrhUsTZCWQQ
         uhBEa1NK5X5DmYB46RRVHTY8cavJdEpkQciO8=
Date: Sun, 23 May 2010 23:03:48 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
Message-ID: <20100523140348.GA10843@barrios-desktop>
References: <4BF81D87.6010506@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF81D87.6010506@cesarb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 03:08:07PM -0300, Cesar Eduardo Barros wrote:
> Add support for checksumming the swap pages written to disk, using the
> same checksum as btrfs (crc32c). Since the contents of the swap do not
> matter after a shutdown, the checksum is kept in memory only.
> 
> Note that this code does not checksum the software suspend image.
We have been used swap pages without checksum.

First of all, Could you explain why you need checksum on swap pages?
Do you see any problem which swap pages are broken?

I could miss your claim at old disucussion thread in LKML.
