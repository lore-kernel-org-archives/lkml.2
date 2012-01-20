Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2ATJ4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:56:10 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:54229 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2ATJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:56:06 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 04:56:05 EST
Message-ID: <4F1937E9.3030409@ge.com>
Date: Fri, 20 Jan 2012 09:46:17 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sam Hansen <solid.se7en@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Manohar Vanga <manohar.vanga@cern.ch>,
        Vincent Bossier <vincent.bossier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Emilio G. Cota" <cota@braap.org>
Subject: Re: [PATCH 1/1] vme: code convention fix
References: <1327050687-8907-1-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1327050687-8907-1-git-send-email-solid.se7en@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2012 09:46:19.0518 (UTC) FILETIME=[5C7531E0:01CCD758]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/12 09:11, Sam Hansen wrote:
> Fixed a code convention violation in vme.h
> 
> Signed-off-by: Sam Hansen <solid.se7en@gmail.com>

Huh, wonder how that got missed when I ran checkpatch over these files.

Good catch,

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 9d38cee..c9d65bf 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -156,7 +156,7 @@ int vme_irq_request(struct vme_dev *, int, int,
>  void vme_irq_free(struct vme_dev *, int, int);
>  int vme_irq_generate(struct vme_dev *, int, int);
>  
> -struct vme_resource * vme_lm_request(struct vme_dev *);
> +struct vme_resource *vme_lm_request(struct vme_dev *);
>  int vme_lm_count(struct vme_resource *);
>  int vme_lm_set(struct vme_resource *, unsigned long long, u32, u32);
>  int vme_lm_get(struct vme_resource *, unsigned long long *, u32 *, u32 *);


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
