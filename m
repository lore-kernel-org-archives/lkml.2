Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1LHB6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:58:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54106 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1LHB6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:58:09 -0500
Message-ID: <4EE01991.4030208@zytor.com>
Date: Wed, 07 Dec 2011 17:57:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1323304882-27953-2-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 04:41 PM, Andi Kleen wrote:
>  
> +/* LOOKS like x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature:*,FEAT,*
> + * All fields are numbers. It would be nicer to use strings for vendor
> + * and feature, but getting those out of the build system here is too
> + * complicated.
> + */

Hmm... how hard can that be, really?  Let me look at it a bit...

	-hpa

