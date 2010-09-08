Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab0IHJiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:38:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52805 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0IHJiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pDmpiHr3V7L4xkzsx1ar4kx9A8IuJ3iIwdwgS/pUP6VQqY22j1KfQIQjnuW6PBl1aJ
         EXx7DU9xK8R/amGY5U4HqV82MSxia9PVCVAsjZ41CMMpLh5x+ZVFGX1yFA1m1UFJa7KX
         oJvS/WXLGEoqkTsMjSZrplPiZ1Ro9vupUe3Oc=
MIME-Version: 1.0
In-Reply-To: <20100908091242.GB31253@rakim.wolfsonmicro.main>
References: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
	<20100908091242.GB31253@rakim.wolfsonmicro.main>
Date: Wed, 8 Sep 2010 18:37:59 +0900
Message-ID: <AANLkTimvc52yXuMFN2=qLKX1MSyTum1GHnLdDW8dMR=2@mail.gmail.com>
Subject: Re: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassi.brar@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 6:12 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Sep 08, 2010 at 01:55:39PM +0900, Jassi Brar wrote:
>> On Tue, Sep 7, 2010 at 7:29 PM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > Allow the use of the S3C64xx SPI controller with things like PMICs by
>> > moving the init up to subsys_initcall().
>
>> Couldn't any user ever need to load it as a module?
>> If no, we might as well drop the s3c64xx_spi_exit and s3c64xx_spi_remove
>
> This doesn't prevent building as a module - when built as a module
> subsys_initcall() is identical to module_init(), the change will only
> affect the order in which things are done when the code is built into
> the kernel otherwise it's a noop.
I didn't know that, thanks for the info.

Acked-by: Jassi Brar <jassi.brar@samsung.com>
