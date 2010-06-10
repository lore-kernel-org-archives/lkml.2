Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab0FJRN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:13:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45137 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0FJRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:13:27 -0400
Message-ID: <4C111D2A.9090704@zytor.com>
Date: Thu, 10 Jun 2010 10:13:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/23] x86 boot: Set ax register in boot vga query
References: <20100610110.764742110@firstfloor.org> <20100610111040.F1781B1A2B@basil.firstfloor.org>
In-Reply-To: <20100610111040.F1781B1A2B@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 04:10 AM, Andi Kleen wrote:
> I think the ax register should be input to the
> BIOS call, not be unused, but not fully sure.  hpa?

Quite correct.  A typo during the conversion to the "glove box" interface.

Thanks, will apply!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

