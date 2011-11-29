Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1K2KRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:17:32 -0500
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1034 "HELO
	smtp-out-211.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753783Ab1K2KRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:17:31 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21917
Message-ID: <4ED4B17C.3090905@metafoo.de>
Date: Tue, 29 Nov 2011 11:18:36 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: drivers@analog.com, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 1/7] firmware: Sigma: Prevent out of bounds
 memory access
References: <1322469860-8210-1-git-send-email-lars@metafoo.de> <20111129101247.GA2851@opensource.wolfsonmicro.com>
In-Reply-To: <20111129101247.GA2851@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 11:12 AM, Mark Brown wrote:
> On Mon, Nov 28, 2011 at 09:44:14AM +0100, Lars-Peter Clausen wrote:
> 
>> Mark, in case you are ok with these patches could you take them through your
>> ASoC tree? The firmware subsystem is orphaned.
> 
> Yeah, I was planning to do that but I was waiting for Mike to be happy
> with everything as he'd had a few concerns on the previous round.  He's
> now acked some but not all of the series but there was no followup on
> the other patches - Mike, are you OK with the other changes?

He acked some patches this morning. As far as I can see all of the patches
do have his acked-by now.

Thanks
- Lars
