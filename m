Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0JZBiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:38:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61050 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZBit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vugW+uM0vuo6UnLZPd7ovXP8K9DxXubs3ge5NL3s/P9m1W29Pdgyx/CnUFDs0RLecM
         MQeUkzi1K/Ob/SHZAFEAEyCbcMZhuyP7CHeWYKtfuSPvG0qhFVpMNxs0E7o2FIq282Dd
         VCpPZLEhyhfVegHjlxy6XduES1sdPpTc+qejw=
MIME-Version: 1.0
In-Reply-To: <20101026011955.GA3432@opensource.wolfsonmicro.com>
References: <1288050954.2323.3.camel@phoenix>
	<20101026011955.GA3432@opensource.wolfsonmicro.com>
Date: Tue, 26 Oct 2010 10:38:48 +0900
X-Google-Sender-Auth: y0wuIsuMsBigrr_3J74CaN5BuuQ
Message-ID: <AANLkTikm5Vsu5kdrS-70LEdoDE1OqzkTo6C=nyPC=oXe@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] regulator: max8952 - fix max8952_set_voltage
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Thank you for your works.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Tue, Oct 26, 2010 at 10:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Oct 26, 2010 at 07:55:54AM +0800, Axel Lin wrote:
>> In current implementation, vid is declared as u8,
>> then "vid == -1" is always false, and "vid >= 0" is always true.
>> Thus change it to s8.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
