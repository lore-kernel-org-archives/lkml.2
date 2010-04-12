Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0DLONg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:13:36 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61702 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:13:35 -0400
Message-ID: <4BC32A58.2040500@ru.mvista.com>
Date: Mon, 12 Apr 2010 18:12:40 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 47/64] ide: add drive->dma_mode field
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172035.14623.50000.sendpatchset@localhost>
In-Reply-To: <20100118172035.14623.50000.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add drive->dma_mode field
>
> Add dma_mode field to ide_drive_t matching dma_mode field used in
> struct ata_device.
>
> The validity of the field is restricted to ->dma_pio_mode method
> only currently in IDE subsystem.
>   

   I don't see such method even in your tree -- perhaps you meant 
set_dma_mode()?

MBR, Sergei

