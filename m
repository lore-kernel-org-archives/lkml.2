Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0IHWPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:15:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab0IHWPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:15:48 -0400
Message-ID: <4C880B12.3040200@zytor.com>
Date: Wed, 08 Sep 2010 15:15:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nick Lowe <nick.lowe@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Promoting Crusoe and Geode Processors to i686 Status
References: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com>	<AANLkTim0GX8bmZu8j5wVs11QFCmKjNK2MBkV7Mcha_Ae@mail.gmail.com>	<4C880278.3060108@zytor.com> <AANLkTimp5kh3Wg5kzfCWq0Rz3uCL7ivu+TED1oHcFDP8@mail.gmail.com>
In-Reply-To: <AANLkTimp5kh3Wg5kzfCWq0Rz3uCL7ivu+TED1oHcFDP8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 03:14 PM, Nick Lowe wrote:
> Hi,
> 
> Here goes...
> 
> -mtune tunes the binary for given architecture. This as opposed to
> defining the baseline architecture, and thus available instruction
> set, which -march does.
> 
> I believe that -mtune is predominantly used for instruction
> scheduling. GCC uses it when it's reordering instructions to optimise
> for specific micro-architecture over others.
> 
> With -mtune=i686, I am of the opinion that you instruct the compiler,
> and give it the opportunity, to deliver a better ordering of the
> instructions. In this case, better ordering for i686 than you would
> get with -mtune=generic32.
> 
> I'm probably wrong somehow, it's probably marginal, and I'll concede
> to your infinitely better knowledge any day! That's why I phrased it
> as a question! :)
> 

We don't pass -mtune=generic32 to gcc.  We pass -Wa,-mtune=generic32 to
gcc, which affects binutils only.

	-hpa
