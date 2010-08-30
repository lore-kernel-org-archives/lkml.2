Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0H3MM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:12:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab0H3MM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:12:56 -0400
Date: Mon, 30 Aug 2010 14:12:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] input: Add support for Hanwang tablet
In-Reply-To: <201008301903259846570@hanwang.com.cn>
Message-ID: <alpine.LNX.2.00.1008301411510.1019@pobox.suse.cz>
References: <201008301903259846570@hanwang.com.cn>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Xing Wei wrote:

>  
> +config TABLET_USB_HANWANG
> +	tristate "Hanwang Art Master III tablet support (USB)"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB
> +	help
> +	  Say Y here if you want to use the USB version of the Hanwang Art
> +	  Master III tablet.  Make sure to say Y to "Mouse support"
> +	  (CONFIG_INPUT_MOUSEDEV) and/or "Event interface support"
> +	  (CONFIG_INPUT_EVDEV) as well.

Is there any reason why you don't have these (MOUSEDEV and EVDEV) as 
explicit Kconfig dependencies?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
