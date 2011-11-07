Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1KGQJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:09:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab1KGQJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:09:06 -0500
Message-ID: <4EB802A0.3050108@suse.cz>
Date: Mon, 07 Nov 2011 17:09:04 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com> <20111026.194045.2019668159403582571.davem@davemloft.net> <4EA8B283.3010105@teksavvy.com> <20111026.221719.2216112919297458522.davem@davemloft.net> <4EB19BBE.5050602@teksavvy.com>
In-Reply-To: <4EB19BBE.5050602@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.11.2011 20:36, Mark Lord wrote:
> +static char driver_version[] =
> +	"ASIX USB Ethernet Adapter: v" DRIVER_VERSION \
> +	" " __TIME__ " " __DATE__ "\n";

Please drop the __TIME__ and __DATE__, it makes each build produce
different object files.

Michal
