Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2JAQdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:33:12 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39932 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab2JAQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:33:08 -0400
Message-ID: <5069C5AF.3030607@iki.fi>
Date: Mon, 01 Oct 2012 19:32:47 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add stk1160 driver
References: <1349101213-21723-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1349101213-21723-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.237
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 05:20 PM, Ezequiel Garcia wrote:
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   MAINTAINERS |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0750c24..17f6fb0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3168,6 +3168,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
>   S:	Maintained
>   F:	drivers/media/usb/gspca/
>
> +STK1160 USB VIDEO CAPTURE DRIVER
> +M:	Ezequiel Garcia <elezegarcia@redhat.com>

Copy paste mistake?

> +L:	linux-media@vger.kernel.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
> +S:	Maintained
> +F:	drivers/media/usb/stk1160/
> +
>   HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
>   M:	Frank Seidel <frank@f-seidel.de>
>   L:	platform-driver-x86@vger.kernel.org
>

regards
Antti

-- 
http://palosaari.fi/
