Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1LBMLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:11:17 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60541 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754473Ab1LBMLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:11:16 -0500
Message-ID: <4ED8C029.7000004@ru.mvista.com>
Date: Fri, 02 Dec 2011 16:10:17 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v1 2/7] omap4: build fdif omap device from hwmod
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <1322817178-8931-3-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1322817178-8931-3-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-12-2011 13:12, Ming Lei wrote:

> Signed-off-by: Ming Lei<ming.lei@canonical.com>
> ---
>   arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
>   1 files changed, 33 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 1166bdc..a392af5 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -728,6 +728,38 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
>
>   #endif
>
> +static struct platform_device* __init omap4_init_fdif(void)

    Shouldn't there be space before *? checkpatch.pl is silent about it?
ALso, I'd have placed '__init' after 'static'...

> +{
> +	int id = -1;
> +	struct platform_device *pd;
> +	struct omap_hwmod *oh;
> +	const char *dev_name = "fdif";

    Why you need this variable at all?

WBR, Sergei

