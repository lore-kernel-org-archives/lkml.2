Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab0J0LHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:07:38 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:48760 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0J0LHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:07:36 -0400
Message-ID: <4CC807A7.3000308@ge.com>
Date: Wed, 27 Oct 2010 12:06:15 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 10/30] staging/vme/tsi148: remove unreachable line
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-11-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-11-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:07:33.0479 (UTC) FILETIME=[27AD1F70:01CB75C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_tsi148.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 5bb999f..c08927e 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2480,7 +2480,6 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	return 0;
>  
> -	vme_unregister_bridge(tsi148_bridge);
>  err_reg:
>  	tsi148_crcsr_exit(tsi148_bridge, pdev);
>  err_crcsr:


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
