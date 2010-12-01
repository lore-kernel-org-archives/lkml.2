Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0LAQtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:49:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34636 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0LAQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hMrNZpz1WxlG8ZaVac2ACu2lkM+GW0DRafFkILax4DQ1AgSfiS+o2iGbf8wWG2wn28
         PQelKaSAU9h6WRX47YGhnR9xKd8r0j4j9FaEIrhaHTy52zJkk2/4Fz/TSZEXGrWhUCKj
         v+AhXBW7Zv79ugW1yRyPoZAUZuo2A9twB5nB4=
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
From: Namhyung Kim <namhyung@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201161039.GB29318@suse.de>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
	 <20101201161039.GB29318@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 01:49:11 +0900
Message-ID: <1291222151.1684.46.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-01 (수), 08:10 -0800, Greg KH:
> On Wed, Dec 01, 2010 at 01:28:41PM +0900, Namhyung Kim wrote:
> > Annotate whci_hcd_id_table as '__used' to fix following warning:
> > 
> >   CC      drivers/usb/host/whci/hcd.o
> > drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used
> 
> Are you seeing this warning when you build the module into the kernel,
> or as a module?
> 
> thanks,
> 
> greg k-h

I saw it during allyesconfig build but not on allmodconfig.
Maybe we can wrap it up in #ifdef CONFIG_MODULES ?

Thanks.

-- 
Regards,
Namhyung Kim


