Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab2JWULH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:11:07 -0400
Received: from mail45.messagelabs.com ([216.82.241.132]:7127 "HELO
	mail45.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933935Ab2JWULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:11:03 -0400
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-4.tower-45.messagelabs.com!1351023061!39834346!1
X-Originating-IP: [91.183.168.164]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
Thread-Index: Ac2xWoX0fFZbg4hTQlaaGiYYmRfimA==
Content-Transfer-Encoding: 7bit
From: "Peter Korsgaard" <peter.korsgaard@barco.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Content-class: urn:content-classes:message
Importance: normal
To: "Kees Cook" <keescook@chromium.org>
Cc: <linux-kernel@vger.kernel.org>, "Stephen Warren" <swarren@nvidia.com>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 050/193] drivers/i2c/muxes: remove CONFIG_EXPERIMENTAL
References: <1351022666-6960-1-git-send-email-keescook@chromium.org><1351022666-6960-51-git-send-email-keescook@chromium.org>
X-message-flag: thor uptime: 188 days, 23:15,  8 users
Date: Tue, 23 Oct 2012 22:11:01 +0200
In-Reply-To: <1351022666-6960-51-git-send-email-keescook@chromium.org> (KeesCook's message of "Tue, 23 Oct 2012 13:02:03 -0700")
Message-ID: <87haplrlt6.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
X-OriginalArrivalTime: 23 Oct 2012 20:11:01.0584 (UTC) FILETIME=[85EF5500:01CDB15A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KC" == Kees Cook <keescook@chromium.org> writes:

KC> This config item has not carried much meaning for a while now and is
KC> almost always enabled by default. As agreed during the Linux kernel
KC> summit, remove it.

Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>


KC> CC: Stephen Warren <swarren@nvidia.com>
KC> CC: Peter Korsgaard <peter.korsgaard@barco.com>
KC> CC: Guenter Roeck <guenter.roeck@ericsson.com>
KC> Signed-off-by: Kees Cook <keescook@chromium.org>
KC> ---
KC>  drivers/i2c/muxes/Kconfig |    2 --
KC>  1 file changed, 2 deletions(-)

KC> diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
KC> index a0edd98..0be5b83 100644
KC> --- a/drivers/i2c/muxes/Kconfig
KC> +++ b/drivers/i2c/muxes/Kconfig
KC> @@ -19,7 +19,6 @@ config I2C_MUX_GPIO
 
KC>  config I2C_MUX_PCA9541
KC>  	tristate "NXP PCA9541 I2C Master Selector"
KC> -	depends on EXPERIMENTAL
KC>  	help
KC>  	  If you say yes here you get support for the NXP PCA9541
KC>  	  I2C Master Selector.
KC> @@ -29,7 +28,6 @@ config I2C_MUX_PCA9541
 
KC>  config I2C_MUX_PCA954x
KC>  	tristate "Philips PCA954x I2C Mux/switches"
KC> -	depends on EXPERIMENTAL
KC>  	help
KC>  	  If you say yes here you get support for the Philips PCA954x
KC>  	  I2C mux/switch devices.
KC> -- 
KC> 1.7.9.5

-- 
Sorry about disclaimer - It's out of my control.
Bye, Peter Korsgaard


DISCLAIMER:
Unless indicated otherwise, the information contained in this message is privileged and confidential, and is intended only for the use of the addressee(s) named above and others who have been specifically authorized to receive it. If you are not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message and/or attachments is strictly prohibited. The company accepts no liability for any damage caused by any virus transmitted by this email. Furthermore, the company does not warrant a proper and complete transmission of this information, nor does it accept liability for any delays. If you have received this message in error, please contact the sender and delete the message. Thank you.
