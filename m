Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0KJUJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:09:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33442 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0KJUJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o2S7c5Y9T7fDl6FlDfJ6BVTD3Wz2w1733YREoG3nN62Ohi7o/qdDbFmHJk+nSU2y0F
         /MPUda55exGbKQbo7Tuc1SeOsEGBpTgWPWNOybjXOdVLJn88lBiq2TGHrYtWd70qmMO9
         gkSoWqe07X13O06mS2rpUZCwv9ePYhp2yLBDQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011102021340.625@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011102021340.625@swampdragon.chaosbits.net>
Date: Wed, 10 Nov 2010 15:09:11 -0500
Message-ID: <AANLkTinBuzRmmZh03k5Ln92eh2O2K72OsMTOgQ_=JjBM@mail.gmail.com>
Subject: Re: Lots of 'warning: <foo> selects <bar> which has unmet direct
 dependencies <baz>' with latest git tree
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Roman Zippel removed from CC list, Michal Marek added.]

On Wed, Nov 10, 2010 at 2:25 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> remote: Counting objects: 1798826, done.
> remote: Compressing objects: 100% (276733/276733), done.
> remote: Total 1798826 (delta 1506575), reused 1798414 (delta 1506266)
> Receiving objects: 100% (1798826/1798826), 353.05 MiB | 1.02 MiB/s, done.
> Resolving deltas: 100% (1506575/1506575), done.
> [jj@dragon src]$ cd linux-2.6
> [jj@dragon linux-2.6]$ make allyesconfig
> scripts/kconfig/conf --allyesconfig Kconfig
> warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TVAUDIO which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C)
> [...]
> warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_UPD64083 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C)
>
This is a known issue, there is patches pending for most of them.

Michal ?

 - Arnaud
