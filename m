Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2FKS0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:26:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60156 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2FKS0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:26:42 -0400
Date: Mon, 11 Jun 2012 09:04:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam Hansen <solid.se7en@gmail.com>
Cc: Sam Hansen <sam@meebo-inc.com>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] staging: zram: conventions, line splitting
Message-ID: <20120611160438.GA24331@kroah.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
 <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 04:03:49PM -0700, Sam Hansen wrote:
> Opting to violate the 80-char limit in favor of not splitting strings onto
> multiple lines (via pr_info()).  This mostly to help readability.
> 
> Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zram/zram_drv.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

This patch no longer applies to the tree :(
