Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab0LFNFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:05:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50828 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0LFNFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KiiNM2ODC517D/DzhjAx52M1QfX0RWZtOcyyNzao2OZJ71/nvK4npXT55G+DMO0MvP
         8CoQ61ClbJPnJJPrv38lQ6qi1C8+kUggzNYFpewz7I6u7RlE2r85A2VJxIVM8cAE619U
         qHrYGHP0r4pxkTCDO/sV2RZlsSB8TxqvZiUaE=
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
From: Namhyung Kim <namhyung@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201173604.GA30708@suse.de>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
	 <20101201161039.GB29318@suse.de> <1291222151.1684.46.camel@leonhard>
	 <20101201173604.GA30708@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 22:05:30 +0900
Message-ID: <1291640730.1696.29.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-01 (수), 09:36 -0800, Greg KH:
> On Thu, Dec 02, 2010 at 01:49:11AM +0900, Namhyung Kim wrote:
> > 2010-12-01 (수), 08:10 -0800, Greg KH:
> > > On Wed, Dec 01, 2010 at 01:28:41PM +0900, Namhyung Kim wrote:
> > > > Annotate whci_hcd_id_table as '__used' to fix following warning:
> > > > 
> > > >   CC      drivers/usb/host/whci/hcd.o
> > > > drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used
> > > 
> > > Are you seeing this warning when you build the module into the kernel,
> > > or as a module?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > I saw it during allyesconfig build but not on allmodconfig.
> > Maybe we can wrap it up in #ifdef CONFIG_MODULES ?
> 
> No, don't do that, your __used is the correct thing here, I just wanted
> to make sure why you were seeing this warning.
> 
> thanks,
> 
> greg k-h

Hi, Greg

It seems this one is not applied in your tree yet. Do you need a resend?

Thanks.


-- 
Regards,
Namhyung Kim


