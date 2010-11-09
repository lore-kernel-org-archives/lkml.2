Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KIUPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:15:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64960 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0KIUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kgJWkXEwjaujV1dTai1Tf8zUP01lIjs/CO7oDmKRozTFg5TBLJzPyW0JmzO4oZQa88
         20lSv3xAXCMZ912qjUqX/5n1gxvkwxHxrukhWg+e99oFuZixw0UqtCts5OtcH4uIguCe
         RNPlOyPfv2oS0rury+kXTH9su8CloSuvhfgko=
MIME-Version: 1.0
In-Reply-To: <20101109163740.GA14733@ericsson.com>
References: <506bc745e46020fb99159fd73288d3b0202c99cf.1287556801.git.joe@perches.com>
	<20101109163740.GA14733@ericsson.com>
Date: Tue, 9 Nov 2010 21:15:04 +0100
Message-ID: <AANLkTi=cTAGuCyk4S-1rscbMUmOm_6X43L7hQTBFmL4y@mail.gmail.com>
Subject: Re: [06/32] drivers/hwmon/asus_atk0110.c: Use pr_fmt and pr_<level>
From: Luca Tettamanti <kronos.it@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 5:37 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Wed, Oct 20, 2010 at 06:51:30AM -0000, Joe Perches wrote:
>> Added #define pr_fmt KBUILD_MODNAME ": " fmt
>> Converted printks to pr_<level>
>> Coalesced any long formats
>> Removed prefixes from formats
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>>
> Applied.
>
> On a side note, I let the long lines go through as long as checkpatch doesn't complain.

I lost sight of the discussion, but I thought that a better solution
was to put the define for pr_fmt in a common header instead of
scattering it in all the drivers.

Luca
