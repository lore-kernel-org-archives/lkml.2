Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0JKQxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:53:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8997 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0JKQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:53:06 -0400
Message-ID: <4CB340F1.8020000@caviumnetworks.com>
Date: Mon, 11 Oct 2010 09:53:05 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Bernhard Walle <walle@corscience.de>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: Add Lanai board USB clock type
References: <1286791747-3151-1-git-send-email-walle@corscience.de>
In-Reply-To: <1286791747-3151-1-git-send-email-walle@corscience.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 16:53:17.0753 (UTC) FILETIME=[CD9E2290:01CB6964]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 03:09 AM, Bernhard Walle wrote:
> Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
> also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.
>
> Signed-off-by: Bernhard Walle<walle@corscience.de>
> ---
>   drivers/staging/octeon/cvmx-helper-board.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)

NAK.

We don't currently support USB, so churning up this file doesn't help 
anything.

If you are using an out-of-tree driver, you can keep this kind of tweak 
out-of-tree as well.

David Daney

>
> diff --git a/drivers/staging/octeon/cvmx-helper-board.c b/drivers/staging/octeon/cvmx-helper-board.c
> index 5793318..f8ae6b4 100644
> --- a/drivers/staging/octeon/cvmx-helper-board.c
> +++ b/drivers/staging/octeon/cvmx-helper-board.c
> @@ -752,6 +752,7 @@ cvmx_helper_board_usb_clock_types_t __cvmx_helper_board_usb_get_clock_type(void)
>   {
>   	switch (cvmx_sysinfo_get()->board_type) {
>   	case CVMX_BOARD_TYPE_BBGW_REF:
> +	case CVMX_BOARD_TYPE_LANAI2_G:
>   		return USB_CLOCK_TYPE_CRYSTAL_12;
>   	}
>   	return USB_CLOCK_TYPE_REF_48;

