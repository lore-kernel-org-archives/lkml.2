Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1GCTPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:15:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39921 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab1GCTO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:14:58 -0400
Date: Sun, 3 Jul 2011 22:14:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: bcm: sort: kill handrolled bubblesort
Message-ID: <20110703191404.GL2544@shale.localdomain>
References: <1309667900-2225-1-git-send-email-chrisf@ijw.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309667900-2225-1-git-send-email-chrisf@ijw.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 04:38:20PM +1200, Chris Forbes wrote:
> Replaced the handrolled bubblesort with the kernel's sort() function.
> Makes things considerably smaller & clearer.
> 

Did you test this?  It's Ok to not test it if you can't but the
changelog should probably say one way or the other.

regards,
dan carpenter
