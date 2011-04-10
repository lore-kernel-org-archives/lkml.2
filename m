Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1DJOPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:15:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62864 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1DJOPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cxUvzG5Enl8llpcjPytwpTP5CeXL7Cyt6ryT5abqymldfsUSooW/GrKle/rRhqrCSO
         T/vTB2BJaVzho3WYB5xf3ysEINTDlI3ICkUpTCFwMPtr5nnISteE4UKEMu3RCYvjUjOe
         ay+Pukc+39xdqapXHDKfWj4v6CUIHvBoKqfZM=
MIME-Version: 1.0
In-Reply-To: <20110410133736.GB1046@sirena.org.uk>
References: <1302368117-32350-1-git-send-email-wanlong.gao@gmail.com>
	<20110410133736.GB1046@sirena.org.uk>
Date: Sun, 10 Apr 2011 22:15:39 +0800
Message-ID: <BANLkTi=Mnu=78qA5J+ePgKv+O+56TFHkjA@mail.gmail.com>
Subject: Re: [PATCH] 2.6.39-rc2:Removed the unused variable for build warnings
From: Wanlong Gao <gaowanlong@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: wanlong.gao@gmail.com, geert@linux-m68k.org, starvik@axis.com,
        jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/11, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, Apr 10, 2011 at 12:55:17AM +0800, wanlong.gao@gmail.com wrote:
>
>>  drivers/regulator/wm831x-dcdc.c    |    2 --
>
> This one is fixed already.  In general you should send separate patches
> for individual subsystems for things like this in order to avoid merge
> issues with overlapping fixes or changes.
> --
 I had resend the patches .
Thanks .
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
