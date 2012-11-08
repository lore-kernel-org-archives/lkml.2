Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2KHJ5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:57:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59862 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2KHJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:57:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121108072915.GD11515@mwanda>
References: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
	<1352314203-8092-5-git-send-email-mujeeb.adil@gmail.com>
	<20121108072915.GD11515@mwanda>
Date: Thu, 8 Nov 2012 15:27:01 +0530
Message-ID: <CANBXnMnXNsfVOpbow5AZ1Xzdhf9GrZE-ndG+OEh8=PJtOfPEfg@mail.gmail.com>
Subject: Re: [PATCH 4/4] Staging: winbond: wb35rx_s: Fixed coding style issue
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 12:59 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> It's better to use more descriptive subjects on the patches.
>
> This one could probably have been broken into smaller patches
> [patch 4/x] Staging: winbond: wb35rx_s: fix white space
> [patch 5/x] Staging: winbond: wb35rx_s: fix comments
> [patch 6/x] Staging: winbond: wb35rx_s: allow header to be included twice
>
> It's small enough that I don't have strong feelings about it, but
> in general that's how you should do it.
>

Thanks Dan for your comment. I'll keep this in mind during my future work.

Regards,
Adil

> regards,
> dan carpenter
>
