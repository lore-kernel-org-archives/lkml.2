Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1CaHRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:17:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64849 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab1CaHRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jMoqw+UXLNDN/O16Kx15/nWG+TZdHd7TZbPMM35yDp4VLrA4C1YlT5NSLdZz2yei8x
         K6EyCbicuE+Y7U90PPq5dvVwm3RghMzerd0Bc+syTJ9r/bu25dpF+VC3qqmdYYX2skZA
         zBnL3ygcoobxCBqd03qs0SwwQrfZ/1MSTUjdw=
MIME-Version: 1.0
In-Reply-To: <ae73e8c570d9ee701af6bad5c1479c3615418826.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
	<ae73e8c570d9ee701af6bad5c1479c3615418826.1301436234.git.joe@perches.com>
Date: Thu, 31 Mar 2011 09:17:48 +0200
Message-ID: <AANLkTimmpL41yL5Z-Gb=iVxz83Q0ob6EOErh6TMHQ9Hb@mail.gmail.com>
Subject: Re: [PATCH 01/23] asus-wmi: Remove __init from asus_wmi_platform_init
From: Corentin Chary <corentin.chary@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 12:21 AM, Joe Perches <joe@perches.com> wrote:
> It's used by a non-init function.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Corentin Chary <corentincj@iksaif.net>

> ---
>  drivers/platform/x86/asus-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index efc776c..c382af6 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1223,7 +1223,7 @@ static int asus_wmi_sysfs_init(struct platform_device *device)
>  /*
>  * Platform device
>  */
> -static int __init asus_wmi_platform_init(struct asus_wmi *asus)
> +static int asus_wmi_platform_init(struct asus_wmi *asus)
>  {
>        int rv;
>
> --
> 1.7.4.2.g597a6.dirty
>
>



-- 
Corentin Chary
http://xf.iksaif.net
