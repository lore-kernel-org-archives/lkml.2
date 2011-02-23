Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1BWRAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:00:37 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:50599 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWRAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:00:35 -0500
Message-ID: <4D653D2E.6000300@ge.com>
Date: Wed, 23 Feb 2011 17:00:30 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, wfp5p@virginia.edu, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: vme: remove unreachable code
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch> <1298467528-26472-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298467528-26472-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 17:00:29.0441 (UTC) FILETIME=[2CB0BF10:01CBD37B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 13:25, Manohar Vanga wrote:
> Removed some unreachable code from vme_register_bridge
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index d9fc864..88bf455 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1363,7 +1363,6 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  
>  	return retval;
>  
> -	i = VME_SLOTS_MAX;
>  err_reg:
>  	while (i > -1) {
>  		dev = &bridge->dev[i];


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
