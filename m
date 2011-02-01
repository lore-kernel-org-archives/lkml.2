Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1BAD62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:58:28 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58755 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1BAD61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:58:27 -0500
Date: Mon, 31 Jan 2011 19:58:24 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, error27@gmail.com, arnd@arndb.de, jj@chaosbits.net,
        joe@perches.com, eric.dumazet@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fixed coding style issues
Message-ID: <20110131195824.45da68d8@nehalam>
In-Reply-To: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
References: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Feb 2011 02:50:24 +0100
Timo von Holtz <tvh@informatik.uni-kiel.de> wrote:

> diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
> index 32909e2..3a0b62d 100644
> --- a/drivers/staging/bcm/Adapter.h
> +++ b/drivers/staging/bcm/Adapter.h
> @@ -14,7 +14,7 @@ struct _LEADER
>  	UCHAR  	Status;
>  	UCHAR	Unused[3];
>  }__attribute__((packed));
> -typedef struct _LEADER LEADER,*PLEADER;
> +typedef struct _LEADER LEADER, *PLEADER;

Rather than fixing format of these typedef's eliminate
them according to CodingStyle

-- 
