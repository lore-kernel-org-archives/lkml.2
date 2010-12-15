Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0LOHDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:03:08 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:44807 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0LOHDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=keJDcT2VL/ByphSJRBgZr6jeo1wlzaDE4Npr0fVRfWVbqOL47+KsXT9Kg3P78V5Zxg
         HcV2xq0yf6IwRIhoEvfk0qS/O059M28uymdP2TH06zrnCyqkE3c5K0TUkZs9wrHG601q
         QPOeQyGNi5nvxm3T+rvyUygT1TeEd0P3zsOa8=
MIME-Version: 1.0
In-Reply-To: <20101214162646.5dd1c0de.randy.dunlap@oracle.com>
References: <20101214162646.5dd1c0de.randy.dunlap@oracle.com>
Date: Wed, 15 Dec 2010 08:03:04 +0100
Message-ID: <AANLkTi=iCwE8E+KW17Skb2AfC99PenJOvjK8vYAfVFFc@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: fix function return type to kill warning
From: Corentin Chary <corentin.chary@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 1:26 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix return type warning:
>
> drivers/platform/x86/eeepc-wmi.c:322: warning: initialization from incompatible pointer type
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/platform/x86/eeepc-wmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- lnx-2637-rc4.orig/drivers/platform/x86/eeepc-wmi.c
> +++ lnx-2637-rc4/drivers/platform/x86/eeepc-wmi.c
> @@ -298,7 +298,7 @@ static void eeepc_wmi_notify(u32 value,
>        kfree(obj);
>  }
>
> -static int store_cpufv(struct device *dev, struct device_attribute *attr,
> +static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
>                       const char *buf, size_t count)
>  {
>        int value;
>


Sorry, too late, :)

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=da7fddf92985c2525260dfd6f70006e022f4457c

Still, Thanks
-- 
Corentin Chary
http://xf.iksaif.net
