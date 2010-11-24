Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0KXG1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:27:04 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40805 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0KXG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:27:02 -0500
Date: Wed, 24 Nov 2010 15:26:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Subject: Re: [PATCH 0/9] sisfb: remove cruft code
Message-ID: <20101124062615.GG11705@linux-sh.org>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:58:42PM +0200, Aaro Koskinen wrote:
> This series deletes unused/unneeded code from sisfb, while not changing
> the functionality.
> 
> Aaro Koskinen (9):
>   sisfb: delete obsolete PCI ROM bug workaround
>   sisfb: delete fallback code for pci_map_rom()
>   sisfb: delete dead SIS_XORG_XF86 code
>   sisfb: delete redudant #define SIS_LINUX_KERNEL
>   sisfb: use CONFIG_FB_SIS_301/315 instead of SIS301/315H
>   sisfb: remove InPort/OutPort wrappers
>   sisfb: replace SiS_SetMemory with memset_io
>   sisfb: move the CONFIG warning to sis_main.c
>   sisfb: delete osdef.h
> 
Applied, thanks.
