Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab1ETPma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:42:30 -0400
Received: from daytona.panasas.com ([67.152.220.89]:54454 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab1ETPm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:42:28 -0400
Message-ID: <4DD68BE0.6030003@panasas.com>
Date: Fri, 20 May 2011 18:42:24 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110430 Remi/fc12 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jim Cromie <jim.cromie@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com> <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
In-Reply-To: <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2011 15:42:27.0509 (UTC) FILETIME=[85911E50:01CC1704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 12:33 AM, Jim Cromie wrote:
> cc: Doug Gilbert <dgilbert@interlog.com>
> cc: linux-scsi@vger.kernel.org
> cc: Benny Halevy <bhalevy@panasas.com>
> cc: Boaz Harrosh <bharrosh@panasas.com>
> cc: osd-dev@open-osd.org
> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> cc: linux-scsi@vger.kernel.org
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  drivers/scsi/osd/osd_uld.c |    6 +++---
>  drivers/scsi/pmcraid.c     |    3 +--
>  drivers/scsi/sg.c          |    6 +++---
>  drivers/scsi/st.c          |    7 +++----
>  4 files changed, 10 insertions(+), 12 deletions(-)

Do you have a git tree with all these that I can pull
and test?

Thanks
Boaz
