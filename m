Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0FGMjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:39:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57434 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0FGMjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=punox4bvty3BAbnWChx5rNPgOb57NSrRWqDpnPYkcFKwJ/Kf7ITGhsJKNkY9QNJTWe
         Rl1MgEt6CX57ZgtkPNWX9SAawcYGS15Ls9b6lXuwzAeavtmzgJvlurP/oGyUaT0X0Rtj
         YO+osy/MevS3MBVcDWw1BUrzzH3P+Lg4eUh3w=
MIME-Version: 1.0
In-Reply-To: <20100607122840.GA13287@rakim.wolfsonmicro.main>
References: <1275626446.1515.5.camel@eight.analog.com> <20100607122840.GA13287@rakim.wolfsonmicro.main>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Jun 2010 08:39:28 -0400
Message-ID: <AANLkTilkzx3eQXc-cOEauj_v0_mZFmh_BVUMw1sgJ1_j@mail.gmail.com>
Subject: Re: [PATCH v6] regulator: new drivers for AD5398 and AD5821
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sonic zhang <sonic.adi@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 08:28, Mark Brown wrote:
> On Fri, Jun 04, 2010 at 12:40:46PM +0800, sonic zhang wrote:
>> +static int __init ad5398_init(void)
>> +{
>> +     return i2c_add_driver(&ad5398_driver);
>> +}
>> +module_init(ad5398_init);
>
> at least some systems are likely to want this to be subsys_initcall() to
> make sure the regulator is available prior to the consumers.  Please
> send an incremental change for this rather than repostnig the full
> thing.

i guess the Blackfin I2C driver should have its initcall bumped up as well
-mike
