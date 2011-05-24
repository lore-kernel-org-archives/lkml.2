Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1EXPUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:20:34 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1EXPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:20:32 -0400
Subject: Re: [PATCH] wireless: Default to 'n' for 2 new added devices in
 Kconfig.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1306249916-6638-1-git-send-email-tm@tao.ma> (sfid-20110524_171245_254728_54F9DE6B)
References: <1306249916-6638-1-git-send-email-tm@tao.ma>
	 (sfid-20110524_171245_254728_54F9DE6B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 08:19:01 -0700
Message-ID: <1306250341.3839.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 23:11 +0800, Tao Ma wrote:

>  config ATH9K_PCI
>  	bool "Atheros ath9k PCI/PCIe bus support"
> +	default n
>  	depends on ATH9K && PCI
>  	default PCI

should just remove the "default PCI" instead, "default n" is the default
if no default is given.

>  config RT2800USB_RT53XX
>         bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
>         depends on EXPERIMENTAL
> -       default y
> +       default n

ditto just remove "default y"

johannes

