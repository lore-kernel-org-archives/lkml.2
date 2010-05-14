Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab0ENI2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:28:17 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61918 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:28:14 -0400
Date: Fri, 14 May 2010 10:28:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, nm127@freemail.hu,
       felixru@gmail.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: fix all coding style issues found by
 checkpatch.pl
Message-ID: <20100514102811.12adc64b@hyperion.delvare>
In-Reply-To: <1273699009-915-1-git-send-email-farid.hammane@gmail.com>
References: <1273699009-915-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Farid,

On Wed, 12 May 2010 23:16:48 +0200, Farid Hammane wrote:
> This patch fixes up all coding style issues found by the checkpatch.pl tool.
> After applying this patch the binary object is still exactly the same.
> 
> Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> ---
>  drivers/i2c/busses/i2c-i801.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)

I already have an equivalent patch in my tree:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-i801-04-coding-style-fixes.patch

-- 
Jean Delvare
