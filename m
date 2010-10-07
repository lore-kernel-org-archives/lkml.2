Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0JGGSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 02:18:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:49189 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0JGGSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:18:41 -0400
Subject: Re: [PATCH] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC controllers (fix)
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20100801105419.GA352@oksana.dev.rtsoft.ru>
Date: Thu, 7 Oct 2010 01:18:19 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Scott Wood <scottwood@freescale.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
        linuxppc-dev@ozlabs.org, Doug Thompson <dougthompson@xmission.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5628792F-9A5F-4200-90B3-FB3939F02969@kernel.crashing.org>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru> <20100716151224.21d499a3@schlenkerla.am.freescale.net> <20100721153933.64d02086.akpm@linux-foundation.org> <20100721182108.5a22c822@schlenkerla.am.freescale.net> <20100801105419.GA352@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2010, at 5:54 AM, Anton Vorontsov wrote:

> On Wed, Jul 21, 2010 at 06:21:08PM -0500, Scott Wood wrote:
> [...]
>>>>> +	{ .compatible = "fsl,p4080-l2-cache-controller", },
>>>> 
>>>> L2 on the p4080 is quite different from those other chips.  It's part
>>>> of the core, controlled by SPRs.
>>> 
>>> erm, was that an ack or a nack?
>> 
>> NACK, p4080 doesn't belong in this table, at least not its L2.
>> 
>> L3 on p4080 is similar to L2 on these other chips, though, and it
>> wouldn't take much to get this driver working on it -- but the match
>> table entry should wait until the differences are accommodated.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> ---
> 
> Scott, thanks for catching this!
> 
> Andrew, please merge this patch into
> edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch
> 
> Thanks!
> 
> drivers/edac/mpc85xx_edac.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index cfa86f7..b178cfa 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -652,7 +652,6 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
> 	{ .compatible = "fsl,p1020-l2-cache-controller", },
> 	{ .compatible = "fsl,p1021-l2-cache-controller", },
> 	{ .compatible = "fsl,p2020-l2-cache-controller", },
> -	{ .compatible = "fsl,p4080-l2-cache-controller", },
> 	{},
> };
> MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
> -- 
> 1.7.0.5

Can you post a new patch as it doesn't look like this got merged by Andrew so we need to clean up after ourselves.

- k

