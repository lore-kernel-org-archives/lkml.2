Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1KDLJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:09:03 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:48170 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1KDLJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:09:01 -0400
Message-ID: <4EB3C69A.6090709@ge.com>
Date: Fri, 04 Nov 2011 11:03:54 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vme: fix comment for struct vme_dev
References: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch> <1320401551-29287-4-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1320401551-29287-4-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2011 11:01:45.0236 (UTC) FILETIME=[24303540:01CC9AE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 10:12, Manohar Vanga wrote:
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index e3828ba..e62a323 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -97,7 +97,7 @@ extern struct bus_type vme_bus_type;
>  
>  /**
>   * Structure representing a VME device
> - * @id: The ID of the device (currently the bus and slot number)
> + * @num: The device number
>   * @bridge: Pointer to the bridge device this device is on
>   * @dev: Internal device structure
>   * @drv_list: List of devices (per driver)


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
