Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0JIScT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:32:19 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47881 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0JIScR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:32:17 -0400
Date: Sat, 9 Oct 2010 11:32:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?UTF-8?B?SmluZMWZaWNoIE1ha292acSNa2E=?= <makovick@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        aabdulla@nvidia.com, ditto@google.com
Subject: Re: [PATCH] forcedeth: reconfigure multicast packet filter only
 when needed
Message-ID: <20101009113213.62c2f131@nehalam>
In-Reply-To: <AANLkTinbgud9enM1XDQrdZVBtGnTFaUeoEL-D8Z2FmJh@mail.gmail.com>
References: <20100812115430.2b5d8683@starbug.prg01.itonis.net>
	<AANLkTinbgud9enM1XDQrdZVBtGnTFaUeoEL-D8Z2FmJh@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010 13:26:05 +0200
Jindřich Makovička <makovick@gmail.com> wrote:

> +
> +	/* current packet filter state */
> +	u32 cur_pff;
> +	u32 cur_addr[2];
> +	u32 cur_mask[2];
>  };

No big deal, but couldn't you just put those temporary variables
on the stack. and reread the current value before stopping.

-- 
