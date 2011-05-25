Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1EYH2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:28:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38362 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1EYH17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s9hvrDj+uSwqdkfg8iKSO/5kEUJPfDJk1/ECsetwYT/hNLZgCDfGfE33KQsACMvmSk
         PeinIe+zzhJGdTAAOuupSwd7GzTpghHzz9kQAK5GkLEhVC7u3a8oeY1NRzX29yXeVxtN
         /cy34yoNSg6wmDM/tvsK5rCpCmF2yEvTbRLI4=
MIME-Version: 1.0
In-Reply-To: <20110524162452.GA22936@pengutronix.de>
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
	<4DDB960F.4050902@monstr.eu>
	<20110524123625.GC31517@suse.de>
	<20110524150215.GA2723@local>
	<20110524162452.GA22936@pengutronix.de>
Date: Wed, 25 May 2011 09:27:57 +0200
X-Google-Sender-Auth: RYFMT_SER8-kwjzpjx0puV_gvnc
Message-ID: <BANLkTinOe5nDB27JKPTNpNyEgKgM0qS=rA@mail.gmail.com>
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
From: Thomas De Schampheleire <patrickdepinguin+devicetree@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, devicetree-discuss@lists.ozlabs.org,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 24, 2011 at 6:24 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> There was some unanswered question by Thomas De Scham, though.
>
> The answers to his question can be found in the discussions around previous
> versions of the patch.
>

I agree. After reading the entire thread a second time, I found the
answer: current 'workaround' is to let users modify the generic
driver's match table, while the real fix is to add runtime adding of
compatible strings to platform devices.

However, the latter functionality is not yet present, right?

Thanks,
Thomas

> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
>
>
