Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1AMQzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:55:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60725 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1AMQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=W1UGDstxxpTOqQdSSgUf3NICi6hOup2V057sQ4lKygzu+MfhsG5iiDDWC8Mgg3kA6P
         2CLj08gv4nzS+sZhFc7q9OyR7FRGU+x0b6KO+ev6RZd5NSw9eAKhSZgkY9MZad4czWx0
         kt+oR5JXzBhhWH9ywB3Br7PPCcTGSBlRhVFT4=
MIME-Version: 1.0
In-Reply-To: <20110113135525.GD11840@opensource.wolfsonmicro.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org> <20110113135525.GD11840@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 13 Jan 2011 11:52:02 -0500
X-Google-Sender-Auth: 8CCT_2uwNEYF73CC1m7Bdzz5xkA
Message-ID: <AANLkTi=5z0u3un8mGoFChMyzgeGY-tajr3iCC-aR6Dv6@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] ASoC: Blackfin TDM: fix missed
 snd_soc_dai_get_drvdata update
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 08:55, Mark Brown wrote:
> On Tue, Jan 11, 2011 at 11:08:19PM -0500, Mike Frysinger wrote:
>> One spot was missed in this driver when converting from
>> snd_soc_dai.private_data to snd_soc_dai_get_drvdata.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Ccing in Liam - Mike, please remember to CC maintainers on patches - and
> dropping the stable lists for now.

i thought you were the ASoC maintainer
-mike
