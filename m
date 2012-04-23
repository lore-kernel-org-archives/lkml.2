Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2DWUZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:25:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53212 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2DWUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:25:06 -0400
Date: Mon, 23 Apr 2012 13:25:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        myungjoo.ham@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove "switch" class in drivers/staging/android/switch
Message-ID: <20120423202502.GA31946@kroah.com>
References: <CAJ0PZbQu6NCo=nYWr_D3yMF5ypaz_SDr6mFWxyN04VO13VmW=Q@mail.gmail.com>
 <1335179997-9911-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335179997-9911-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 08:19:57PM +0900, MyungJoo Ham wrote:
> Because extcon can also be a switch class for legacy userspace (Android)
> and is a superset of switch class in drivers/staging/android/switch,
> switch class may be removed.
> 
> - Remove switch class
> - Remove switch class consideration in extcon class
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Very nice, now applied.

Thanks again for pushing this code through, it's much appreciated.

greg k-h
