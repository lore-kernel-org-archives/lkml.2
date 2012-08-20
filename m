Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2HTNon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:44:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59189 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2HTNol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:44:41 -0400
X-Auth-Info: gzL/7UFRYMzsHwWDES/rH9bmV7k517BE1bnI2QNEPzc=
From: Marek Vasut <marex@denx.de>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Subject: Re: [PATCH 3/3] IIO: arm: Add LRADC to i.MX28 dts
Date: Mon, 20 Aug 2012 15:41:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>
References: <1344784918-32352-1-git-send-email-marex@denx.de> <20120820075249.GJ24242@S2101-09.ap.freescale.net> <5031EDD7.1050404@jic23.retrosnub.co.uk>
In-Reply-To: <5031EDD7.1050404@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208201541.17732.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan Cameron,

> On 20/08/12 08:52, Shawn Guo wrote:
> > On Mon, Aug 20, 2012 at 08:29:23AM +0100, Jonathan Cameron wrote:
> >> Mostly these prefixes are an excuse for grumpy maintainers to moan
> >> at people :)
> > 
> > Yeah, I have to become grumpy when my comment gets ignored and I have
> > to make it right (for several times) to avoid my upstream moaning at me.
> 
> Not at all. My upstream has never moaned at me about it, but I still
> like to moan about it myself ;)

Your upstream is enjoyable to work with :)

> > Is it so hard?  You are not creating a new subsystem but just patching
> > an existing file.  A "git log" on the file simply shows you how to do it
> 
> Indeed. A file listing these would be add just one more piece of largely
> pointless horrendous documentation.

I was thinking more like a list of tags ... based on directories or something. 
But giving it a further thought, I see the trouble now.

> Perhaps if Marek feels particularly strongly about this, proposing an
> additional line to for the SubmittingPatches document to say get your
> title format by looking at the log for what you are patching will do
> the job? (I can't immediately spot anything equivalent in there...)

That might just be it ;-)

Thanks

Best regards,
Marek Vasut
