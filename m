Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1A3Gd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 01:33:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58595 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1A3Gd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 01:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ieR9eOMopUDFsSRQCrvjM5AeZA0N5O5GtJZgxzFEE1TvG1OWITEJb9Sx+QK07NxZpa
         Y/qJOlTKOmqVhasui6IzIBgCmLHfEN+L+Gbv3zP773d7CwVkwkMNaVSfT1r9msKyUg7E
         SN3PSNk2mbc5SqsfZSgX2UuFVkBC32DSDL+7E=
MIME-Version: 1.0
In-Reply-To: <1295881154.2903.7.camel@hcegtvedt>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
	<1295619115-18420-5-git-send-email-jamie@jamieiles.com>
	<1295881154.2903.7.camel@hcegtvedt>
Date: Sat, 29 Jan 2011 22:33:26 -0800
X-Google-Sender-Auth: PTCfopLdWF_CdCqX1o0X8B4Pn_k
Message-ID: <AANLkTimYqH1+ELS44Mg+cptgS9h8s09wdW+iSW5Feepk@mail.gmail.com>
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst masters
From: Dan Williams <dan.j.williams@intel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 6:59 AM, Hans-Christian Egtvedt
<hans-christian.egtvedt@atmel.com> wrote:
> On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote:
>> Now that the dw_dmac DMA driver supports configurable source and
>> destination masters we need to specify which ones to use. This was
>> previously hardcoded to 0 and 1 respectively in the driver.
>>
>> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

I applied 1-4 will try to submit for 2.6.38 as these were ready before
the merge window opened.

Thanks,
Dan
