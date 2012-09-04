Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2IDRVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:21:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35907 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab2IDRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:21:18 -0400
Date: Tue, 4 Sep 2012 10:21:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: otg: Move phy interface to separate file.
Message-ID: <20120904172112.GA22494@kroah.com>
References: <1346748958-10200-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346748958-10200-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:25:58PM +0530, Venu Byravarasu wrote:
> As otg.h is containing lots of phy interface related
> stuff, moving all phy interface related stuff to new
> file named phy.h
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@xxxxxxxxxx>

For some reason, I don't think that is a valid email address :(

