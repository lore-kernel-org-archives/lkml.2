Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1BWJTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:19:18 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:36361 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWJTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:19:14 -0500
Message-ID: <4D64D10A.3070702@ge.com>
Date: Wed, 23 Feb 2011 09:19:06 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: cota@braap.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] Staging: vme: remove unreachable code
References: <1298403376-28352-1-git-send-email-manohar.vanga@cern.ch> <1298403376-28352-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298403376-28352-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 09:19:05.0368 (UTC) FILETIME=[B7B27180:01CBD33A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/11 19:36, Manohar Vanga wrote:
> Remove unreachable code from vme_register_bridge
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Yeah - that's there from development. If the function needed to be extended,
that's the next part of the error path.

Not sure how leaving lines like this are viewed in the kernel code, I'm happy
for this to be removed if it's not considered good practice. In that case:

Acked-by: Martyn Welch <martyn.welch@ge.com>

Martyn

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
