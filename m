Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab0FBEwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:52:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41095 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0FBEwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iHP5ef8ZkkUXOmytFt9/LXzLVEHGOZQg6T0uv6kERGATDs7RzhVq5wI6f5fTjAlBpl
         j4sVc4dhObHR6x9NkYK7Lrpn4Rdidm0/hCi+Yy3tGfu7YnzXW1qDTs5YLUVbTaUAScNO
         UUHSMgUpsur9Z1vwimtCQqlHSTa6IyTUGn7ho=
MIME-Version: 1.0
In-Reply-To: <20100601142558.GD863@rakim.wolfsonmicro.main>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
	<1275399239-6788-2-git-send-email-vapier@gentoo.org>
	<20100601142558.GD863@rakim.wolfsonmicro.main>
Date: Wed, 2 Jun 2010 12:52:38 +0800
Message-ID: <AANLkTin5mU_EkaVtGYw1kDsIM1o4BGwomcEr1aFRSnrv@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: new driver for the AD12{2,3,4,5}, AD150, 
	and AD5022 parts
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jun 01, 2010 at 09:33:59AM -0400, Mike Frysinger wrote:
>
>> With userspace consumer enabled, power devices with only one switch
>> PIN connect to GPIO port can be enabled and disable via sysfs interface.
>
> This looks exactly like a fixed voltage regualtor except there is no
> facility for reporting the voltage.  Why is a new driver being supplied?

Yes, you are right. AD122, AD123, AD124, AD125, AD150 and AD5022 can
reuse the fixed voltage regulator.
Please ignore this patch.


Sonic

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
