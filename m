Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1KXTHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:07:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53849 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1KXTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:07:53 -0500
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20111123215111.GD3258@mwanda>
Date: Thu, 24 Nov 2011 14:07:49 -0500
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Content-Transfer-Encoding: 7bit
Message-Id: <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda> <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com> <20111123145020.GA3258@mwanda> <4ECD1A01.3060503@mev.co.uk> <4ECD6873.7080106@metafoo.de> <20111123215111.GD3258@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kcalloc looks good to me.  Do you want to redo the patch in that way?

- xi

On Nov 23, 2011, at 4:51 PM, Dan Carpenter wrote:
> 
> I think the reason why I didn't do that in my original patch is that
> kcalloc() has a memset(..., 0, ...) in it so it's a slow down.  But
> this isn't performance critical code so that would work.
> 
> regards,
> dan carpenter

