Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0FLSXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 14:23:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42521 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0FLSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 14:23:07 -0400
Message-ID: <4C13D051.4060903@zytor.com>
Date: Sat, 12 Jun 2010 11:22:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, AMD: Extend support to future families
References: <20100602182921.GA21557@aftab> <4C101B58.2090208@zytor.com> <20100612041504.GB14077@aftab>
In-Reply-To: <20100612041504.GB14077@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 09:15 PM, Borislav Petkov wrote:
> 
> Not yet. And I'm assuming you're driving at tagging it for -stable?
> If yes, I think a stable tag makes sense since this way the distros
> will pick it up more easily and we most definitely will need to do the
> backport later otherwise.
> 
> Do you need another version with the stable tag resent or is it easier
> for you to edit the commit message of the one you have already?
> 

No, I'm not -- Linus is being really snippy about wanting regressions
only this cycle, which this is not.  Once .35 is out you can talk to
Greg about -stable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

