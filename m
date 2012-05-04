Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2EDU7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:59:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43208 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2EDU7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:59:41 -0400
Message-ID: <4FA44339.2010808@wwwdotorg.org>
Date: Fri, 04 May 2012 14:59:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Wolfgang Denk <wd@denx.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <4FA432E9.9050606@wwwdotorg.org> <20120504203857.49EAD206451@gemini.denx.de>
In-Reply-To: <20120504203857.49EAD206451@gemini.denx.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 02:38 PM, Wolfgang Denk wrote:
> Dear Stephen,
> 
> In message <4FA432E9.9050606@wwwdotorg.org> you wrote:
>>
>> representation of how to identify the child boards, and then have the
>> kernel only use/parse certain chunks of the DT based on the ID results.
> 
> I expect that this will quickly cause problems, for example in those
> many cases where pins and peripheral functions are multiplexed, or
> usable for different purposes. I would not want to maintain a DT that
> has to describe all combinations used by some boards - in a way that
> does not cause conflicts on either of them.

With the DT pinctrl bindings, you can define the pinctrl configuration
required to interact with particular child boards in the DT chunk for
that child board. So, I think this would work out fine; you wouldn't
have to represent a huge maze/array of conditional pinctrl settings in
the main board file.
