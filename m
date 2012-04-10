Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2DJPXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:23:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50131 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2DJPXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:23:03 -0400
Message-ID: <4F845054.3070400@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:23:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [linux-next][PATCH] regmap: fix build error if !CONFIG_DEBUG_FS
References: <1334038367.15859.12.camel@phoenix> <20120410084346.GF3149@opensource.wolfsonmicro.com> <CAF+7xW=Rfj8vtoTCy7szgYpEMw1nW0HVR64b4mgJtjCoBbGi4A@mail.gmail.com>
In-Reply-To: <CAF+7xW=Rfj8vtoTCy7szgYpEMw1nW0HVR64b4mgJtjCoBbGi4A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 02:56 AM, Axel Lin wrote:
> 2012/4/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> On Tue, Apr 10, 2012 at 02:12:47PM +0800, Axel Lin wrote:
>>> Fix build error introduced by commit 9eba4d
>>> "regmap: fix compilation when !CONFIG_DEBUG_FS".
>>
>> I've no idea what tree you're testing against but Stephen's fix is
>> needed for -next.
> 
> I'm testing with today's linux-next tree.
> It's strange in today's linux-next tree that "git show 79c64d5" can
> show the commit,
> but git log cannot find commit 79c64d5.

I checked internal.h and regmap.c in next-20120410 and they seem exactly
matched at present.

Yes, commit 79c64d5 doesn't exist. The real commit ID is
d3c242e1f22f5dfed009296ee45ce896153f0b53 (i.e. the one right before
commit 9eba4d). This is because the commit in question got moved between
topic branches.
