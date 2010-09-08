Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0IHVjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:39:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37875 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0IHVjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:39:06 -0400
Message-ID: <4C880278.3060108@zytor.com>
Date: Wed, 08 Sep 2010 14:39:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nick Lowe <nick.lowe@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Promoting Crusoe and Geode Processors to i686 Status
References: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com> <AANLkTim0GX8bmZu8j5wVs11QFCmKjNK2MBkV7Mcha_Ae@mail.gmail.com>
In-Reply-To: <AANLkTim0GX8bmZu8j5wVs11QFCmKjNK2MBkV7Mcha_Ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 05:27 PM, Nick Lowe wrote:
> 
> 2) Should there be the special case that forces the suboptimal
> -mtune=generic32 to work around the binutils NOPL bug or, as I think,
> should people just update to a sane binutils version? (It's a special
> case triggered where CONFIG_X86_P6_NOP is not set.)
> 

What's suboptimal about it?

	-hpa
