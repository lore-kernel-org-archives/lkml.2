Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2HWAAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:00:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20579 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2HWAAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:00:00 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-01-5035727e6fb0
Message-id: <5035727D.9080001@samsung.com>
Date: Thu, 23 Aug 2012 08:59:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org
Subject: Re: [PATCH RESEND] extcon: fix typos in extcon-arizona
References: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
 <1345663663-4790-4-git-send-email-pmeerw@pmeerw.net>
In-reply-to: <1345663663-4790-4-git-send-email-pmeerw@pmeerw.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd36ItMAg1nPmS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxDP+BUe4KvZv62VpYLzB0cXIySEhYCJx5WQLE4QtJnHh3nq2
	LkYuDiGBRYwSv2ZfZYVwupgkTn/aAFbFK6Al8bH1KCOIzSKgKnHs3Sd2EJsNKL7/xQ2gbg4O
	UYEIiV/9HBDlghI/Jt9jAQmLCPhIHHpUChJmFiiVeLTvAthEYQF7ib8P/rCA2EIC5RKXN3wB
	m8gp4Cjxd/ckJoh6HYn9rdPYIGx5ic1r3jJPYBSYhWTDLCRls5CULWBkXsUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHHzPpHcwrmqwOMQowMGoxMObEWsaIMSaWFZcmXuIUYKDWUmE94YB
	UIg3JbGyKrUoP76oNCe1+BCjNAeLkjgvf59hgJBAemJJanZqakFqEUyWiYNTqoFx5be7G98W
	dx3fzvf6yH3lXKaE06a7Px1/1bV+p0fDVJM1sXMdmRyr5R/x26yRKTb65/vx2Ae9+5mT2m7d
	n1mRKnPbJ2bhrhlSd/xyp21UcmDxXPdV2+N4HsttlrOxHofcqw5s6w5u7O+K2XBpS+hGngnx
	35Ie1Zk19sp6HdXey7x9waqy9OMvlFiKMxINtZiLihMB9hRnFjoCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:27 AM, Peter Meerwald wrote:

> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
> ---
>  drivers/extcon/extcon-arizona.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 427a289..6d24822 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -313,7 +313,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
>  
>  	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>  	if (!info) {
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		dev_err(&pdev->dev, "Failed to allocate memory\n");
>  		ret = -ENOMEM;
>  		goto err;
>  	}
> @@ -350,7 +350,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
>  
>  	ret = extcon_dev_register(&info->edev, arizona->dev);
>  	if (ret < 0) {
> -		dev_err(arizona->dev, "extcon_dev_regster() failed: %d\n",
> +		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
>  			ret);
>  		goto err;
>  	}


Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I will apply this patch to
http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next
and you can check it after some hours.

Thank you
Chanwoo Choi
