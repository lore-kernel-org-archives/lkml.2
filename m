Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2KJIAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 03:00:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53432 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2KJIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 03:00:14 -0500
Date: Sat, 10 Nov 2012 00:00:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 2/3] input: stmpe-ts: Use devm_*() routines
Message-ID: <20121110080009.GA12015@core.coreip.homeip.net>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
 <52b9fe53a8bd8dff7105209c5b1fab9da7a1510d.1352474824.git.viresh.kumar@linaro.org>
 <CAKohpomC1KTLk=UVim4gdYhJ5kngTZHOUvUgckD75AVH1w+FHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomC1KTLk=UVim4gdYhJ5kngTZHOUvUgckD75AVH1w+FHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Nov 09, 2012 at 10:34:35PM +0530, Viresh Kumar wrote:
> On 9 November 2012 20:57, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > This patch frees stmpe-ts driver from tension of freeing resources :)
> > devm_* derivatives of multiple routines are used while allocating resources,
> > which would be freed automatically by kernel.
> >
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Fixup:
> 
> commit dda6d45808d65aaf8b0d4153e7a418b255365818
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Fri Nov 9 22:28:26 2012 +0530
> 
>     fixup! input: stmpe-ts: Use devm_*() routines
> ---
>  drivers/input/touchscreen/stmpe-ts.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/stmpe-ts.c
> b/drivers/input/touchscreen/stmpe-ts.c
> index 9896095..f2cb15d 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -344,8 +344,6 @@ static int __devexit stmpe_ts_remove(struct
> platform_device *pdev)

Sometimes your mailer does wrap long lines, please make sure to turn it
off for patches.

There is no need to resend this one.

Thanks.

-- 
Dmitry
