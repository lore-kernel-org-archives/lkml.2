Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1BKPJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:09:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab1BKPJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v5D7z0CQADiohENIdgG6Qw3pfcDCg+m67VWS9pfK3eV0LCC+nJ46PqBKELGgajM6/t
         HSc1wLVDN2ArBG1X1ffFmvFRZY7h6Lg4Mylk3UcmrAgkUMHrtrdMk9YgN5I2c4/IT5zy
         4NsiWnnBMAOtqOzbMT4hOkpTwoQb7jm2cTqJo=
Subject: Re: [PATCH 4/6] Platform support MSP onchip USB controller.
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110211140600.GA23348@linux-mips.org>
References: <1295943725-20308-1-git-send-email-anoop.pa@gmail.com>
	 <20110211140600.GA23348@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 20:59:27 +0530
Message-ID: <1297438167.29250.72.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 15:06 +0100, Ralf Baechle wrote:
> On Tue, Jan 25, 2011 at 01:52:05PM +0530, Anoop P.A wrote:
> 
> > +#ifdef CONFIG_MSP_HAS_DUAL_USB
> > +#define NUM_USB_DEVS   2
> > +#else
> > +#define NUM_USB_DEVS   1
> > +#endif
> 
> I thought you meant to replace CONFIG_MSP_HAS_DUAL_USB with a runtime
> check?

No. I added that as an configuration option will be used in future.
> 
>   Ralf


