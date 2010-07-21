Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab0GUOCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0GUOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:02:00 -0400
Message-ID: <4C46FDCD.9010007@redhat.com>
Date: Wed, 21 Jul 2010 09:01:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-r5 ext3 corruptions
References: <20100715105745.GI30737@dastard>	<20100719224512.GD32635@dastard>	<20100721063222.GW32635@dastard> <20100721140758.68ca16ab@debian>
In-Reply-To: <20100721140758.68ca16ab@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> On Wed, 21 Jul 2010 16:32:22 +1000
> Dave Chinner <david@fromorbit.com> wrote:

...

>> Quite frankly, data=writeback mode for ext3 is a dangerous,
>> dangerous configuration to run by default. IMO, it shouldn't be the
>> default. Patch below.
> 
> Hi,
> 
> I don't see CONFIG_EXT3_DEFAULTS_TO_ORDERED in my .config at all.
> What I have in my .config is:
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_USE_FOR_EXT23=y
> CONFIG_EXT4_FS_XATTR=y
> 
> So what is the equivalent of that config option for ext4 used as ext3
> driver?

There is none AFAICT, just an artifact of the twisting option-paths of
extN, I guess.  :)

Good news is you should get something sane, and -not- default to writeback
with your config.

-Eric

> Best regards,
> --Edwin

