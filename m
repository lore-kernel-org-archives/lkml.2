Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2J1KzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:55:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53456 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2J1KzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:55:14 -0400
Message-ID: <508D0ECA.8040008@mvista.com>
Date: Sun, 28 Oct 2012 14:54:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, linux-scsi@vger.kernel.org,
        devel@open-fcoe.org, virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/16] treewide: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
References: <cover.1351411047.git.joe@perches.com>
In-Reply-To: <cover.1351411047.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-10-2012 12:05, Joe Perches wrote:

> dev_<level> create smaller objects than dev_printk(KERN_<LEVEL>.
> Convert non-debug calls to this form.

> Joe Perches (16):
>    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
[...]
>    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
[...]
>    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

    Hm, somehow this patch is repeated thrice?

MBR, Sergei

