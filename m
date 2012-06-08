Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab2FHHec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:34:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60739 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab2FHHeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:34:31 -0400
Message-ID: <4FD1AAFB.1010904@vflare.org>
Date: Fri, 08 Jun 2012 00:34:19 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sam Hansen <solid.se7en@gmail.com>
CC: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: zram: conventions pr_warning -> pr_warn()
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com> <1339100404-18773-2-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1339100404-18773-2-git-send-email-solid.se7en@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:20 PM, Sam Hansen wrote:

> Porting zram to use the pr_warn() function instead of the deprecated
> pr_warning().
> 
> Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 


Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
