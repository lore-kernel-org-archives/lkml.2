Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab1JNQpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:45:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49523 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab1JNQpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:45:47 -0400
Message-ID: <4E986738.9050504@pobox.com>
Date: Fri, 14 Oct 2011 12:45:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pata_sil680: minor CodingStyle fixups
References: <201110112021.51236.bzolnier@gmail.com> <4E957080.6020102@mvista.com> <20111012120305.0b5f8f06@lxorguk.ukuu.org.uk>
In-Reply-To: <20111012120305.0b5f8f06@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 07:03 AM, Alan Cox wrote:
>
>>
>>> +	/* This last case is _NOT_ ok */
>>> +	case 0x30:
>>> +		printk(KERN_ERR "sil680: Clock disabled ?\n");
>>
>>      pr_err()? Or checkpatch.pl doesn't complain about it (I forgot)?
>
> dev_ would be even better but that seems to be a separate thing. The
> existing patch is still a move in the right direction.

agreed x 2

To be specific, it should be

	dev_err(&pdev->dev

