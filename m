Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1CJACP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:02:15 -0500
Received: from kroah.org ([198.145.64.141]:32866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1CJACM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:02:12 -0500
Date: Wed, 9 Mar 2011 16:00:22 -0800
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] Coding style and minor changes in ft1000_hw.
Message-ID: <20110310000022.GA17741@kroah.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:21:05AM +0100, Marek Belisko wrote:
> Marek Belisko (21):
>   staging: ft1000: Replace camelcase CardSendCommand function name.
>   staging: ft1000: Fix coding style in card_send_command function.
>   staging: ft1000: Fix coding style in dsp_reload function.
>   staging: ft1000: Fix coding style in ft1000_reset_asic function.
>   staging: ft1000: Fix coding style in ft1000_reset_card function.
>   staging: ft1000: Fix identation in ftnet_ops struct.
>   staging: ft1000: Fix coding style in init_ft1000_netdev function.
>   staging: ft1000: Change return value for init_ft1000_netdev function.
>   staging: ft1000: Fix coding style in reg_ft1000_netdev function.
>   staging: ft1000: Fix coding style in ft1000_reset function.
>   staging: ft1000: Fix coding style in ft1000_usb_transmit_complete
>     function.
>   staging: ft1000: Fix coding style in ft1000_copy_down_pkt function.
>   staging: ft1000: Fix coding style in ft1000_start_xmit function.
>   staging: ft1000: Fix coding style in ft1000_submit_rx_urb function.
>   staging: ft1000: Fix coding style in ft1000_copy_up_pkt function.
>   staging: ft1000: Fix coding style in ft1000_open function.
>   staging: ft1000: Fix coding style in ft1000_close function.
>   staging: ft1000: Fix coding style in ft1000_chkcard function.
>   staging: ft1000: Fix coding style in ft1000_receive_cmd function.
>   staging: ft1000: Fix coding style in ft1000_dsp_prov function.
>   staging: ft1000: Fix coding style in ft1000_proc_drvmsg function.
> 
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    6 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    | 1724 +++++++++++-----------
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    4 +-

After applying this series, I get the following build error:
	drivers/staging/ft1000/ft1000-usb/ft1000_hw.c: In function ‘ft1000_proc_drvmsg’:
	drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:1825:5: error: implicit declaration of function ‘CardSendCommand’

So I've dropped the whole series.

Care to try it again?

thanks,

greg k-h
