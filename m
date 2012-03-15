Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874Ab2CORRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:17:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56698 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2CORRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:17:06 -0400
Date: Thu, 15 Mar 2012 21:17:00 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: =?utf-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        Axel Lin <axel.lin@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] power, max8998: Include linux/module.h just once in
 drivers/power/max8998_charger.c
Message-ID: <20120315171700.GE11441@oksana.dev.rtsoft.ru>
References: <32079635.330331328493473417.JavaMail.weblogic@epml22>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32079635.330331328493473417.JavaMail.weblogic@epml22>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 01:57:54AM +0000, 함명주 wrote:
> > Remove the duplicate.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

> 
> > ---
> >  drivers/power/max8998_charger.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
> > index 9b3f2bf..5c5f281 100644
> > --- a/drivers/power/max8998_charger.c
> > +++ b/drivers/power/max8998_charger.c
> > @@ -21,7 +21,6 @@
> >  
> >  #include <linux/module.h>
> >  #include <linux/err.h>
> > -#include <linux/module.h>
> >  #include <linux/slab.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/power_supply.h>
> > -- 
> > 1.7.9

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
