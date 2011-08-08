Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1HHOdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:33:14 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60604 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1HHOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:33:12 -0400
Date: Mon, 8 Aug 2011 16:32:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kernel-janitors@vger.kernel.org, linux390@de.ibm.com,
        Stefan Weinhuber <wein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] drivers/s390/block/dasd_ioctl.c: add missing kfree
Message-ID: <20110808143255.GA19688@osiris.boeblingen.de.ibm.com>
References: <1312802283-9107-5-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312802283-9107-5-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:17:59PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Data is only used to temporarily hold information to be copied to the user
> level, so it should be freed before leaving the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

[...]

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/s390/block/dasd_ioctl.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Applied. Thanks!
