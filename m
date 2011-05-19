Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab1ESRbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:31:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38093 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESRba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ln1CIK6ulb+NkUpPsEV3Tr4WXMJT7fl3EuhvM0wUmifJ7zi2/dpoSpAnJBQeFN70YV
         fM6UPx1L8VjYQPL/SIes7EkdKxs4Q8pn/gC3TrcS5MQoyeml763+ndLUWCuELTJDtakG
         cZRU3roC2rsHQvBIMcvNnFzDHxfrvQ4dFxdzw=
MIME-Version: 1.0
In-Reply-To: <20110519085234.2784f588.randy.dunlap@oracle.com>
References: <20110519135941.2fda46ca.sfr@canb.auug.org.au>
	<20110519085234.2784f588.randy.dunlap@oracle.com>
Date: Thu, 19 May 2011 20:29:26 +0300
Message-ID: <BANLkTi=PyyFxvL3YUJcO=2GTrHpjwG-RLA@mail.gmail.com>
Subject: Re: [PATCH -next] staging: fix mei build when PM is not enabled
From: Tomas Winkler <tomasw@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 6:52 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix mei build when CONFIG_PM is not enabled (i.e., fix typo):
>
> drivers/staging/mei/main.c:1159: error: 'MEI_PM_OPS' undeclared here (not in a function)
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/staging/mei/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20110519.orig/drivers/staging/mei/main.c
> +++ linux-next-20110519/drivers/staging/mei/main.c
> @@ -1145,7 +1145,7 @@ static int mei_pci_resume(struct device
>  static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
>  #define MEI_PM_OPS     (&mei_pm_ops)
>  #else
> -#define MIE_PM_OPS     NULL
> +#define MEI_PM_OPS     NULL
>  #endif /* CONFIG_PM */
>  /*
>  *  PCI driver structure

Thanks for catching this
Ack
Tomas
