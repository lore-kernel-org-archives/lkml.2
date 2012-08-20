Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2HTH5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:57:16 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:46559 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2HTH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:57:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5031EDD7.1050404@jic23.retrosnub.co.uk>
Date: Mon, 20 Aug 2012 08:57:11 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] IIO: arm: Add LRADC to i.MX28 dts
References: <1344784918-32352-1-git-send-email-marex@denx.de> <201208170457.03686.marex@denx.de> <CAAQ0ZWROobdtFkzn9Sr7v5B29zYTQ5YEUZV59kkNE_yv6qbmgQ@mail.gmail.com> <201208191730.31969.marex@denx.de> <5031E753.5070200@jic23.retrosnub.co.uk> <20120820075249.GJ24242@S2101-09.ap.freescale.net>
In-Reply-To: <20120820075249.GJ24242@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/12 08:52, Shawn Guo wrote:
> On Mon, Aug 20, 2012 at 08:29:23AM +0100, Jonathan Cameron wrote:
>> Mostly these prefixes are an excuse for grumpy maintainers to moan
>> at people :)
>
> Yeah, I have to become grumpy when my comment gets ignored and I have
> to make it right (for several times) to avoid my upstream moaning at me.
Not at all. My upstream has never moaned at me about it, but I still 
like to moan about it myself ;)
>
> Is it so hard?  You are not creating a new subsystem but just patching
> an existing file.  A "git log" on the file simply shows you how to do it
>
Indeed. A file listing these would be add just one more piece of largely
pointless horrendous documentation.

Perhaps if Marek feels particularly strongly about this, proposing an
additional line to for the SubmittingPatches document to say get your
title format by looking at the log for what you are patching will do
the job? (I can't immediately spot anything equivalent in there...)


