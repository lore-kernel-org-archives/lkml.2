Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1LWSx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:53:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1LWSxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:53:25 -0500
Message-ID: <4EF4CE4A.1020907@gmail.com>
Date: Fri, 23 Dec 2011 10:54:02 -0800
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: multitouch: add support of Atmel multitouch
 panels
References: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com> <1324651260-4067-2-git-send-email-benjamin.tissoires@gmail.com>
In-Reply-To: <1324651260-4067-2-git-send-email-benjamin.tissoires@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 06:40 AM, Benjamin Tissoires wrote:
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/Kconfig          |    1 +
>  drivers/hid/hid-ids.h        |    3 +++
>  drivers/hid/hid-multitouch.c |    5 +++++
>  3 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 5d6eb4e..e95b07c 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -335,6 +335,7 @@ config HID_MULTITOUCH
>  	  Say Y here if you have one of the following devices:
>  	  - 3M PCT touch screens
>  	  - ActionStar dual touch panels
> +	  - Atmel panels
>  	  - Cando dual touch panels
>  	  - Chunghwa panels
>  	  - CVTouch panels

I'm guessing this is different than the Atmel maXTouch chips. If so, can
you figure out a model name so people aren't confused on which driver to
use?

-- Chase
