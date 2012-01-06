Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab2AFBrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:47:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38652 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2AFBre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:47:34 -0500
Date: Fri, 6 Jan 2012 05:47:30 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bq20z75: fix devicetree match table
Message-ID: <20120106014729.GA11316@oksana.dev.rtsoft.ru>
References: <1324607824-2685-1-git-send-email-olof@lixom.net>
 <1325616406.13090.1.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1325616406.13090.1.camel@rklein-linux2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 10:46:46AM -0800, Rhyland Klein wrote:
> On Thu, 2011-12-22 at 18:37 -0800, Olof Johansson wrote:
> > It should be an of module table, not i2c.
> > 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > ---
> >  drivers/power/bq20z75.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> > index ce95ff7..3efca54 100644
> > --- a/drivers/power/bq20z75.c
> > +++ b/drivers/power/bq20z75.c
> > @@ -622,7 +622,7 @@ static const struct of_device_id bq20z75_dt_ids[] = {
> >  	{ .compatible = "ti,bq20z75" },
> >  	{ }
> >  };
> > -MODULE_DEVICE_TABLE(i2c, bq20z75_dt_ids);
> > +MODULE_DEVICE_TABLE(of, bq20z75_dt_ids);
> >  
> >  static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
> >  		struct i2c_client *client)
> 
> Acked-by: Rhyland Klein <rklein@nvidia.com>

Applied, thanks! (The driver is 'sbs-battery' nowadays. So I modified
the patch a little bit.)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
