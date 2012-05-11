Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946356Ab2EKWaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:30:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49878 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946334Ab2EKW35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
	<1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org>
Date: Fri, 11 May 2012 15:29:56 -0700
Message-ID: <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] scsi/megaraid: fix sparse warnings
From: adam radford <aradford@gmail.com>
To: mathieu.poirier@linaro.org
Cc: JBottomley@parallels.com, megaraidlinux@lsi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 3:09 PM,  <mathieu.poirier@linaro.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
...
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index bfd87fa..234ad74 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -51,55 +51,16 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>
> +#include "mega_common.h"

Do not include mega_common.h in the megaraid_sas driver.  It has
nothing to do with this driver.  It is for the older Parallel SCSI
megaraid drivers.

-Adam
