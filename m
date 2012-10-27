Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2J0QTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:19:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46168 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab2J0QTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:19:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121027150649.GC3349@kroah.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
	<1351325129-10097-5-git-send-email-clouds.yan@gmail.com>
	<20121027150649.GC3349@kroah.com>
Date: Sun, 28 Oct 2012 00:19:04 +0800
Message-ID: <CAH+=+MGFxzENSy2stbgv5BQvgSbgKtsSnn2Fuj+O-zw8-2Ljfg@mail.gmail.com>
Subject: Re: [PATCH 5/5] debugfs: remove goto in debugfs_remount()
From: Yan Hong <clouds.yan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/27 Greg KH <gregkh@linuxfoundation.org>:
> On Sat, Oct 27, 2012 at 04:05:29PM +0800, Yan Hong wrote:
>> Simple code clean to remove goto.
>
> There is nothing wrong with gotos on error paths, so this one should
> stay.
>
> greg k-h

I thought we use goto on error path because there is no other elegant
ways to do the things, but it sounds like goto is still welcome and preferable
when we are not in this case. Anyway, this is a simple clean, I do not insist
on it.

Thanks
