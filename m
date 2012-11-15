Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2KOVt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:49:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54338 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2KOVt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:49:26 -0500
Message-ID: <50A56335.5020100@zytor.com>
Date: Thu, 15 Nov 2012 13:48:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mingo@elte.hu,
        tglx@linutronix.de, herrmann.der.user@googlemail.com, bp@alien8.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <20121115204503.GB18032@khazad-dum.debian.net> <50A55E04.9020606@amd.com>
In-Reply-To: <50A55E04.9020606@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 01:26 PM, Boris Ostrovsky wrote:
>>
>> Because it looks like without this patch, some valid microcode updates
>> would be rejected by the kernel...
>
> Right, patch loading will fail.
>
> I wasn't sure whether stable would be appropriate since this is support
> for new HW. OTOH since this would result in loss of functionality one
> could consider this a bug.
>

I already promoted it and will push it into -tip as soon as it passes my 
smoke tests.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

