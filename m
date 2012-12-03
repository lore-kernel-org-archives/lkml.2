Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2LCSju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:39:50 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59846 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2LCSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:39:46 -0500
Message-ID: <50BCF1EC.7090300@pobox.com>
Date: Mon, 03 Dec 2012 13:39:40 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_piix: re-oder code and remove prototypes
References: <201211301156.04953.b.zolnierkie@samsung.com> <50BCFDAD.6070209@mvista.com>
In-Reply-To: <50BCFDAD.6070209@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 02:29 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 11/30/2012 01:56 PM, Bartlomiej Zolnierkiewicz wrote:
>
>> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Subject: [PATCH] ata_piix: re-oder code and remove prototypes
>
>     You meant "re-order", I think.
>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Jeff, please apply.  Thanks!
>
>     Perhaps Jeff can correct the typo too...

Yep, corrected and results in libata-dev.git already



