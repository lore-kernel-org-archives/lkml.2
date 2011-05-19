Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab1ESUa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:30:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60095 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab1ESUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:30:26 -0400
Date: Thu, 19 May 2011 21:30:18 +0100
From: Andy Whitcroft <apw@canonical.com>
To: John Stoffel <john@stoffel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, neilb@suse.de,
        hramrach@centrum.cz, jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110519203018.GK3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
 <20110519163709.GH3702@shadowen.org>
 <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
 <19925.27077.673335.609614@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19925.27077.673335.609614@quad.stoffel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:04:37PM -0400, John Stoffel wrote:

> One question I have is why is a LiveCD even using the LSM modules?
> It's not like it tells you anything you don't know... unless you're
> planning on mounting some external disks and then reading in the LSM
> checksums from somewhere to confirm.
> 
> Just curious.  

Cause the LiveCD has the same kernel we want in the installed system on
it, so its there warts and all.

-apw
