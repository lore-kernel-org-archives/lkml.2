Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1JNRgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:36:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57644 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab1JNRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:36:47 -0400
Message-ID: <4E98732D.8040707@pobox.com>
Date: Fri, 14 Oct 2011 13:36:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ata_piix: re-oder code and remove prototypes
References: <201110131544.50339.bzolnier@gmail.com>
In-Reply-To: <201110131544.50339.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 09:44 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] ata_piix: re-oder code and remove prototypes
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/ata_piix.c |  335 ++++++++++++++++++++++---------------------------
>   1 file changed, 157 insertions(+), 178 deletions(-)

please update assuming absence of patch #3...



