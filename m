Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1KYI6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:58:20 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1125 "HELO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751223Ab1KYI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:58:19 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26557
Message-ID: <4ECF58E9.9070903@metafoo.de>
Date: Fri, 25 Nov 2011 09:59:21 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com
Subject: Re: [PATCH 6/8] ASoC: SigmaDSP: Provide diagnostic error messages
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-6-git-send-email-lars@metafoo.de> <201111241232.43809.vapier@gentoo.org>
In-Reply-To: <201111241232.43809.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 06:32 PM, Mike Frysinger wrote:
> On Thursday 24 November 2011 07:48:25 Lars-Peter Clausen wrote:
>> +	if (crc != le32_to_cpu(ssfw_head->crc)) {
>> +		dev_err(&client->dev, "Failed to load firmware: Wrong crc checksum:" \
>> +			" expected %x got %x.\n",
> 
> it's my understanding that string constants should not be split
> -mike

I think it is fine here. You probably wouldn't grep for %x anyway.
