Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1AYENL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 23:13:11 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:55193 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752186Ab1AYENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 23:13:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJrcPU1Ld/sX/2dsb2JhbAAMhAfMQZBkgSSDOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,372,1291611600"; 
   d="scan'208";a="89129924"
Message-ID: <4D3E4DD1.60705@teksavvy.com>
Date: Mon, 24 Jan 2011 23:13:05 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net>
In-Reply-To: <20110125005555.GA18338@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-24 07:55 PM, Dmitry Torokhov wrote:
>
> No, as far as I know we kept ABI intact.


Okay, I hacked lsinput and input-kbd to ignore the protocol number.
input-kbd is still broken: it thinks my remote control (Hauppauge)
has only ten buttons, and won't allow me to remap codes larger than 10.

I've now hacked around that too, but without determining exactly
where the interface got broken.

Ugh.

Thanks.
