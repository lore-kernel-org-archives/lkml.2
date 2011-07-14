Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1GNUmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:42:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48496 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1GNUl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E1F53D9.2000606@zytor.com>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<1310462166-31469-14-git-send-email-tj@kernel.org>
	<4E1F4D2C.3000507@zytor.com>
	<CAOS58YPhFWEYgB7moPoTj+BKBn6WMHCi5FqZ5eYp+m4bbEN_7A@mail.gmail.com>
	<4E1F5040.50004@zytor.com>
	<CAOS58YM38mwmLcErARLc2+7wBrBa5Je3VOM5L28z63L6+ysqpQ@mail.gmail.com>
	<4E1F53D9.2000606@zytor.com>
Date: Thu, 14 Jul 2011 22:41:59 +0200
X-Google-Sender-Auth: PXscXJwm-qowyB5lDgvuvF-Zh50
Message-ID: <CAOS58YPkDG2v3ULRMK15mwvpAKyPpjYL34N+BMZwWZB3DNOEnw@mail.gmail.com>
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 14, 2011 at 10:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Hmm... I was only looking at the early boot messages which didn't
>> include the io ranges.  It ultimately is a cosmetic issue so my
>> opinions aren't very strong but I think we can leave [mm]io ranges
>> alone and converge the rest into [ ) ranges sans the brackets?
>
> Agreed it's a cosmetic issue... this discussion has already been had,
> though, and the consensus is to move the kernel to the standardized
> resource format.

OIC, in that case, please go ahead and change it.  It seems that we
haven't been too successful at applying the decision tho. :(

Thanks.

-- 
tejun
