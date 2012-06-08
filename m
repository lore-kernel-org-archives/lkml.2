Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab2FHHm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:42:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47594 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2FHHm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:42:28 -0400
Message-ID: <4FD1ACD8.4040700@vflare.org>
Date: Fri, 08 Jun 2012 00:42:16 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sam Hansen <solid.se7en@gmail.com>
CC: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] staging: zram: conventions, line splitting
References: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com> <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 04:03 PM, Sam Hansen wrote:

> Opting to violate the 80-char limit in favor of not splitting strings onto
> multiple lines (via pr_info()).  This mostly to help readability.
> 
> Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 


Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
