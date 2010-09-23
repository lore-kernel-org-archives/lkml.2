Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0IWVvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:51:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34584 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab0IWVvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZeHK/lzo5IsN9CkWvdugtDcSyxsIlF/7CE0VXom4gaSr5RMl0AlDuLOv8et3W1L90j
         kMtEE8BuaFamHQ5bbpCwu42iw+Dw1psfEMjYIZaP+vyPBLuuJlxIza8PK2b3Pe1w6FYj
         kcJbmYCBTAkVlOrI901Ac/8z3tnWWkKPbCZmI=
MIME-Version: 1.0
In-Reply-To: <20100923195450.GA27852@srcf.ucam.org>
References: <20100923195450.GA27852@srcf.ucam.org>
Date: Thu, 23 Sep 2010 23:51:39 +0200
Message-ID: <AANLkTincMJ6ydnwM4+FMsd2FPkSUgN97hWtEOu+sn2OK@mail.gmail.com>
Subject: Re: [GIT] x86 platform driver update
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 9:54 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Hi Linus,
>
> Just an update to MAINTAINERS and a fix for a regression in the Thinkpad
> hotkey handling.
>
> The following changes since commit 57aebd7739c8dbbf403876ee1e9673fafc83d856:
>
>  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2010-09-23 08:06:55 -0700)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus
>
> Henrique de Moraes Holschuh (1):
>      thinkpad-acpi: avoid keymap pitfall
>
> Lee, Chun-Yi (1):
>      Change MSI LAPTOP driver maintainer to Lee, Chun-Yi
>
>  MAINTAINERS                          |    4 +---
>  drivers/platform/x86/thinkpad_acpi.c |    5 +++--
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Matthew,
You didn't include "asus-laptop: fix gps rfkill", which fix a NULL
dereference when there is a GPS device.
I think this patch should really be merged (also sent it to
stable@kernel.org, for previous version).
Maybe we should open a patchwork for platform-x86 ml to tack patchs ?
There was one on linux-acpi,
and it was really helpful.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
