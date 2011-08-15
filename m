Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1HOHYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:24:09 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:34453 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1HOHYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:24:08 -0400
Date: Mon, 15 Aug 2011 17:26:15 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Arnaud Lacombe <lacombar@gmail.com>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH 01/11] arch/m68k: do not use EXTRA_{A,C,LD}FLAGS
In-Reply-To: <1313384834-24433-2-git-send-email-lacombar@gmail.com>
Message-ID: <alpine.OSX.2.00.1108151724491.211@ibook.local>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com> <1313384834-24433-2-git-send-email-lacombar@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Aug 2011, Arnaud Lacombe wrote:

> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y += -DTRAP_DBG_INTERRUPT
> +# ccflags-y += -DTRAP_DBG_INTERRUPT

asflags-y?

Finn
