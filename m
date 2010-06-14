Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0FNK63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:58:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35915 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0FNK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=t3179HUzHbYE1A9WkyE1fCjkfCdFhPrADmGaHLbCwOGg38i36YA61b4mX+1MnXprT7
         ExkIVtv9H9r71cCSc6k2PgLRedmXUBT7mIHxzQ9L8z3FgdWpvfAV3auxvfnr6WiF2JmN
         Eog2Mzsp9tcMtUYPWihrxE/qzyLOKKBuAVxbU=
MIME-Version: 1.0
In-Reply-To: <20100614103548.GA19679@excalibur.local>
References: <0680EC522D0CC943BC586913CF3768C003B34A60A3@dbde02.ent.ti.com>
	<20100614103548.GA19679@excalibur.local>
Date: Mon, 14 Jun 2010 12:58:26 +0200
Message-ID: <AANLkTimW1UOz516wBgJ8ia67GUfWElfLFdpiwXncd2x7@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
From: Christoph Mair <christoph.mair@gmail.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 14, 2010 at 12:35 PM, Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
> Hello.
>
> On Mon, 2010-06-14 at 15:43, Datta, Shubhrajyoti wrote:
>> Adding support for BMP085 pressure sensor.
>> The interface of the device is I2C.
>> The driver is based on a version initially written by Christoph
>> Mair.
>
> Did you coordinate with Christoph on this driver? I used it myself and the last
> time I talked to Christoph he was planning to brining it mainline himself. Added
> him to cc to keep him in the loop.

I already merged the input specific additions from Shubhrajyoti into
my latest code, but I still have to push the changes to my repository.
I'll do this as soon as I can test the driver. Then I will send a new
patch which will also contain fixes for issues raised on the ML.

Best Regards,
  Christoph Mair
