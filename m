Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1GSP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:28:39 -0400
Received: from mail.perches.com ([173.55.12.10]:4175 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1GSP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:28:37 -0400
Subject: Re: [PATCH 1/2] serial:blackfin: Correct coding style in bfin
 serial driver.
From: Joe Perches <joe@perches.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <1311070165-29402-1-git-send-email-sonic.adi@gmail.com>
References: <1311070165-29402-1-git-send-email-sonic.adi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 08:28:35 -0700
Message-ID: <1311089315.2286.157.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 18:09 +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
[]
> @@ -1091,10 +1090,18 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
>  				*parity = 'o';
>  		}
>  		switch (lcr & 0x03) {
> -			case 0:	*bits = 5; break;
> -			case 1:	*bits = 6; break;
> -			case 2:	*bits = 7; break;
> -			case 3:	*bits = 8; break;
> +		case 0:
> +			*bits = 5;
> +			break;
> +		case 1:
> +			*bits = 6;
> +			break;
> +		case 2:
> +			*bits = 7;
> +			break;
> +		case 3:
> +			*bits = 8;
> +			break;
>  		}

Maybe just:
	*bits = 5 + (lcr & 3);

