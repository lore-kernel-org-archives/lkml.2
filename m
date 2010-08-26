Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0HZGKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:10:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58480 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0HZGK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=JMx/Hh6L9du1Fu0IdjbNSw86cMStmGnJdA1CfoWg8grVnQ9Esqw9I4DvDPC5e93DbX
         w3629F0T6ZYeWltM8TdNZLH7XQEVGG8SOOsMMNFJbHSDi5xi7zRvKps9Af6zcY6VO2jL
         3sfxgLy+UOQzDMgd/TpzdV0Xe6rXEsJnU7YP8=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100825132212.GB1102@opensource.wolfsonmicro.com>
References: <1282726751.5051.4.camel@mola> <20100825132212.GB1102@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 26 Aug 2010 14:10:06 +0800
Message-ID: <AANLkTinTiOmGo4fpHnOdVPSTH1DuWQeLVvh1ysmwhVM0@mail.gmail.com>
Subject: Re: [PATCH] ASoC: pxa-ssp: fix a memory leak in pxa_ssp_remove()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/25 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Aug 25, 2010 at 04:59:11PM +0800, Axel Lin wrote:
>> The "priv" allocated in pxa_ssp_probe() should be kfreed in pxa_ssp_remove().
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> This doesn't apply against current ASoC.  I fixed this up by hand since
> the error was so trivial but in future could you please make sure you
> generate your code against the latest version of ASoC?  This will be in
> -next at any given time, or for the individual tree you want the latest
> for-2.6.nn branch of:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git
>

Thanks, Mark.
I just thought this fix should be applied to 2.6.36.
And ASoC tree will have this fix after merge 2.6.36.

Regards,
Axel
