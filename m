Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1KDLHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:07:36 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:50931 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1KDLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:07:35 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Nov 2011 07:07:34 EDT
Message-ID: <4EB3C642.5040304@ge.com>
Date: Fri, 04 Nov 2011 11:02:26 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vme: fix comment in __vme_register_driver()
References: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch> <1320401551-29287-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1320401551-29287-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2011 11:00:17.0736 (UTC) FILETIME=[F008C480:01CC9AE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 10:12, Manohar Vanga wrote:
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index b04b468..3cbc69c 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1421,10 +1421,7 @@ static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  		 * and if the bridge is removed, it will have to go through
>  		 * vme_unregister_bridge() to do it (which calls remove() on
>  		 * the bridge which in turn tries to acquire vme_buses_lock and
> -		 * will have to wait). The probe() called after device
> -		 * registration in __vme_register_driver below will also fail
> -		 * as the bridge is being removed (since the probe() calls
> -		 * vme_bridge_get()).
> +		 * will have to wait).
>  		 */
>  		err = __vme_register_driver_bus(drv, bridge, ndevs);
>  		if (err)


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
