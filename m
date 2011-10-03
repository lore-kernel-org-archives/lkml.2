Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1JCARp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:17:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45618 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1JCARm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:17:42 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111002182605.GC2857@opensource.wolfsonmicro.com>
References: <1317562466.4996.2.camel@phoenix> <20111002182605.GC2857@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 3 Oct 2011 08:17:21 +0800
Message-ID: <CAF+7xWkfTJXwt1uUtXgkh5Go9yxWasdM5a3DuLnii_5LqB00UQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: samsung: s3c-i2s-v2.c needs module.h
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sun, Oct 02, 2011 at 09:34:26PM +0800, Axel Lin wrote:
>> Include <linux/module.h> to fix below build error:
>>
>>   CC      sound/soc/samsung/s3c-i2s-v2.o
>> sound/soc/samsung/s3c-i2s-v2.c:573: warning: data definition has no type or storage class
>
> What tree is this for?  My primary development platform is based on this
> driver, I'd expect to have noticed any build issues and I rather suspect
> this isn't what you're supposed to do after all the module.h stuff has
> settled down.
>
I got the build error on linux-next (20110930).
