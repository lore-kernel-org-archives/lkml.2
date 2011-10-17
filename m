Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1JQXbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:31:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1JQXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:31:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=vpEfbloNCdW9jcC1enBj/PO2LlG4M7ryBgot/4eEKzP2nrCrFiucouQwEYgmIt3Hc
	DYcZVyOeAa+umZIGwYtQA==
Date: Mon, 17 Oct 2011 16:31:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mpn@google.com>
cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?Q?Re=3A_=5BPATCHv6_1=2F3=5D_usb=3A_gadget=3A_replace_=E2=80=9Cis=5Fdualspeed=E2=80=9D_with_=E2=80=9Cmax=5Fspeed=E2=80=9D?=
In-Reply-To: <d4b21b6bf1cf87f49c654be3bd85c38dabaced0a.1318875728.git.mina86@mina86.com>
Message-ID: <alpine.DEB.2.00.1110171629430.13515@chino.kir.corp.google.com>
References: <cover.1318875728.git.mina86@mina86.com> <d4b21b6bf1cf87f49c654be3bd85c38dabaced0a.1318875728.git.mina86@mina86.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Michal Nazarewicz wrote:

> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index c4a6e14..9e3aeb5 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -592,3 +592,10 @@ Why:    In 3.0, we can now autodetect internal 3G device and already have
>  	interface that was used by acer-wmi driver. It will replaced by
>  	information log when acer-wmi initial.
>  Who:    Lee, Chun-Yi <jlee@novell.com>
> +
> +---------------------------
> +
> +What:	is_dualspeed sysfs entry in udc-core.c and ci13xxx_udc.c
> +When:	3.8
> +Why:	is_dualspeed is superseded by maximum_speed/max_speed.
> +Who:	Michal Nazarewicz <mina86@mina86.com>

Please specify the exact files that are being removed from sysfs, nobody 
is going to understand what they're losing unless they look at the code.
