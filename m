Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1ILJF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:05:26 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:41225 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1ILJFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:05:24 -0400
Message-ID: <4E6DCB62.1070406@ladisch.de>
Date: Mon, 12 Sep 2011 11:05:38 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: 3.1-rc5 is the worst
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
In-Reply-To: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC to alsa-devel and Takashi)

Francis Moreau wrote:
> Maybe the subject sounds rude so apologize since I just want to report
> that 3.1-rc5 gives me bad impression.
> 
> 1/ I'm getting this now at each boot:
> 
>   [   38.349671] hda_codec: too deep connection for 0x18
>   [   38.349748] hda_codec: too deep connection for 0x18
>   [   38.349842] hda_codec: too deep connection for 0x18
>   [   38.349843] hda_codec: too deep connection for 0x18
>   [   38.349844] hda_codec: too deep connection for 0x18
>   [   38.349939] hda_codec: too deep connection for 0x18
>   <repeated 252 times>
> 
> I've no idea what it does mean or it's simply a warning I can ignore
> (and it that case it would be nice to limit it at least) or if it's
> worse getting a fix before 3.1 is out would be great.
> ...
