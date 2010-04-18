Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0DRKxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 06:53:55 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64423 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0DRKxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 06:53:54 -0400
Date: Sun, 18 Apr 2010 12:53:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: ben-linux@fluff.org, w.sang@pengutronix.de, giometti@linux.it,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-core: fix some coding style issues in i2c-core.c
Message-ID: <20100418125351.58c97bca@hyperion.delvare>
In-Reply-To: <1271580067-13619-1-git-send-email-farid.hammane@gmail.com>
References: <1271580067-13619-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Farid,

On Sun, 18 Apr 2010 10:41:07 +0200, Farid Hammane wrote:
> This is a patch to the i2c-core.c file that fixes up coding style issues found by the checkpatch.pl tool
> 
> Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> ---
>  drivers/i2c/i2c-core.c |   86 ++++++++++++++++++++++++------------------------
>  1 files changed, 43 insertions(+), 43 deletions(-)

Ironically, your patch itself triggers 5 checkpatch errors. I'll fix
them. Thanks for the patch, consider it applied.

-- 
Jean Delvare
