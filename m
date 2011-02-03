Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1BCEYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:24:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62828 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab1BCEYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J2tshHFveZJgt15tHTvVipxc3LV83qLzl5FLc93qSV44jYWrZZxOb9PIAxUsvjL20Q
         XrIO5ofm+Ai72F/3d1TaKoqmH5zlGIZFgShyWlBk43CSCG+Y3nef4lYXNN7TNCP/WOMR
         YClHsa26nAnqNryff7JdHHDtl+rpJV8Paed/k=
MIME-Version: 1.0
In-Reply-To: <1296699980-30234-1-git-send-email-thomas@wytron.com.tw>
References: <AANLkTimoaJKy-WTTHmRXFMmM6=e7uvzhjwRcDtNqGAPj@mail.gmail.com>
	<1296699980-30234-1-git-send-email-thomas@wytron.com.tw>
Date: Wed, 2 Feb 2011 20:24:06 -0800
Message-ID: <AANLkTinOZxbuZ7EpG6uT3vJdY_9LwgEg5G30_M4TEceA@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio: add devicetree support
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 6:26 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> This patch adds devicetree support to i2c-gpio driver. It converts
> dts bindings and allocates a struct i2c_gpio_platform_data, which
> will be freed on driver removal.
>
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Acked-by: Haavard Skinnemoen <hskinnemoen@gmail.com>
