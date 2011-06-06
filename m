Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1FFJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:52:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53959 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab1FFJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:52:14 -0400
Message-ID: <4DECA33E.5040306@ti.com>
Date: Mon, 6 Jun 2011 10:51:58 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: Jonathan Cameron <jic23@cam.ac.uk>, "perex@perex.cz" <perex@perex.cz>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dp@opensource.wolfsonmicro.com" <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wm8940: remove unecessary if statement
References: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu> <4DEC9E6B.8030505@cam.ac.uk>
In-Reply-To: <4DEC9E6B.8030505@cam.ac.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 10:31, Jonathan Cameron wrote:
> On 06/06/11 01:47, Greg Dietsche wrote:
>> the code always returns ret regardless, so if(ret) check is unecessary.
> Good point, though please spell check your commit messages.
> unecessary -> unnecessary
> 
> Also if you want to do this sort of cleanup, please also fix the
> equivalent in wm8940_resume and wm8940_add_widgets.  Ack is for
> what is here, plus those if you do them.
> 
> Just as an aside, there is no earthly point in cc'ing lkml for a
> simple cleanup like this. Just adds to already huge amount of noise!
>>
>> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Acked-by: Liam Girdwood <lrg@ti.com>
