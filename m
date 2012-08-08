Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2HHD55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:57:57 -0400
Received: from void.printf.net ([89.145.121.20]:55991 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab2HHD5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:57:55 -0400
From: Chris Ball <cjb@laptop.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Tony Olech <tony.olech@elandigitalsystems.com>,
        kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/mmc/host/vub300.c: add missing usb_free_urb
References: <1343142370-27876-2-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 07 Aug 2012 23:57:51 -0400
In-Reply-To: <1343142370-27876-2-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Tue, 24 Jul 2012 17:06:10 +0200")
Message-ID: <878vdqujb4.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Tue, Jul 24 2012, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Add missing usb_free_urb on failure path after usb_alloc_urb.

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
