Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0KYN4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:56:22 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59961 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0KYN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kqV2LvmR6f8b7yCdwU1hypmoW2SIkE3xSzyM3tc6q0eco46ihoN70yC50bNYvaP6st
         zjsxvEof8Pr6Abk5Qxbwrznk/AhudTxBsRiHEMvCLV7XXGiwCXg/KFsBl1IqFP7L5NzB
         Al2Ob/t42VeXEV1fZGru4ub3oKz5xvPVcBltM=
Date: Thu, 25 Nov 2010 16:56:14 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lin Mac <mkl0301@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
Message-ID: <20101125135614.GA22212@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
 <1290443565-20766-3-git-send-email-mkl0301@gmail.com>
 <20101124161122.GA15902@oksana.dev.rtsoft.ru>
 <AANLkTimMEALmH08RKQet_MGiyEFYpD2kVtPtmKJpmhtZ@mail.gmail.com>
 <20101125104817.GA31779@oksana.dev.rtsoft.ru>
 <AANLkTikDFe55ksjia85WSecsUw+VQpYnVO-xCkhdmcYO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikDFe55ksjia85WSecsUw+VQpYnVO-xCkhdmcYO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 09:51:23PM +0800, Lin Mac wrote:
> 2010/11/25 Anton Vorontsov <cbouatmailru@gmail.com>:
> > On Thu, Nov 25, 2010 at 03:25:38PM +0800, Lin Mac wrote:
> > [...]
> >> >  #include <linux/module.h>
> >> >  #include <linux/io.h>
> >> >  #include <linux/delay.h>
> >> > +#include <asm/atomic.h>
> >> It's not necessary for mach/pm.h already included it, right?
> >
> > Technically, it's not necessary. But in Linux we don't rely on
> > headers including other headers. Think that someday mach/pm.h
> > may not include asm/atomic.h, so the build will break.
> >
> > Thanks,
> 
> Get it. So should I re-submit all 3 patches, or just the last one?

Just the last one, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
