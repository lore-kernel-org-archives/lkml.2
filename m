Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1GTWpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:45:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62632 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1GTWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:45:43 -0400
Message-ID: <4E275A93.4050705@lwfinger.net>
Date: Wed, 20 Jul 2011 17:45:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Convert printks to pr_<level>
References: <b57f00fc1d0947443aa1830c11c288e78924af44.1311177059.git.joe@perches.com>
In-Reply-To: <b57f00fc1d0947443aa1830c11c288e78924af44.1311177059.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 10:51 AM, Joe Perches wrote:
> Use the current logging styles.
> Add pr_fmt where appropriate.
> Remove now unnecessary prefixes from printks.
> Convert hard coded prefix to __func__.
> Add a missing "\n" to a format.
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   drivers/net/wireless/rtlwifi/base.c               |    9 ++-
>   drivers/net/wireless/rtlwifi/cam.c                |    4 +-
>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    5 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |   69 ++++++++------------
>   drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      |   11 ++-
>   drivers/net/wireless/rtlwifi/rtl8192de/sw.c       |    8 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c       |   10 ++--
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c      |    5 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/rf.c       |    4 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/sw.c       |    6 +-
>   drivers/net/wireless/rtlwifi/usb.c                |   12 ++--
>   11 files changed, 72 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
> index bc13533..d88e405 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -27,6 +27,8 @@
>    *
>    *****************************************************************************/

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


