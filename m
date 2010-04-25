Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0DYMHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 08:07:34 -0400
Received: from poutre.nerim.net ([62.4.16.124]:64500 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0DYMHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 08:07:33 -0400
Date: Sun, 25 Apr 2010 14:07:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, Enrik.Berkhan@ge.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] i2c-algo-pca: fix coding style issues in
 i2c-algo-pca.c
Message-ID: <20100425140730.555f76de@hyperion.delvare>
In-Reply-To: <1272119654-8976-1-git-send-email-farid.hammane@gmail.com>
References: <1272119654-8976-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Farid,

On Sat, 24 Apr 2010 16:34:14 +0200, Farid Hammane wrote:
> This patch fixes up some coding style issues. i2c-algo-pca.c has been
> build successfully after applying this patch and the binary object is
> still exactly the same.
> Other issues found by checkpatch.pl were voluntarily not fixed, either
> to keep readability, or because of false positive errors.
> 
> Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> ---
>  drivers/i2c/algos/i2c-algo-pca.c |   36 ++++++++++++++++++------------------
>  1 files changed, 18 insertions(+), 18 deletions(-)

Applied, thanks.

-- 
Jean Delvare
