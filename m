Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1KMKUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:20:24 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:59280 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1KMKUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:20:23 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/16] mtd/docg3: fix BCH registers
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	<1320912342-30147-5-git-send-email-robert.jarzmik@free.fr>
	<4EBECBA2.1030606@newsguy.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 13 Nov 2011 11:20:14 +0100
In-Reply-To: <4EBECBA2.1030606@newsguy.com> (Mike Dunn's message of "Sat, 12
	Nov 2011 11:40:18 -0800")
Message-ID: <87r51ciash.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Dunn <mikedunn@newsguy.com> writes:

> On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
>> -#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 1))
>> +#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 0))
>
>
> Minor nit:  why the 0, and not just (0x1048 + idx) ?
I'll fix that, old idea I had that address bus did not stand odd adresses, and I
couldn't convince myself the "<< 0" was right, so left it to have back quicky
"<< 1". But I was wrong :)

Cheers.

-- 
Robert
