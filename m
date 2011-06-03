Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1FCH63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:58:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51518 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1FCH62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=H7n3aWmqyeGE7CqJtcl67pLh1eR1+QHN2dY38GZLmaMxIfHLinb+MsD92+5HCZi5cj
         dk5Xcj4lB+TvK9Q8Q5i8fApUSzQbngo0Z15Y0ytC1rPwMoYbbL36z0bEndIbG252sJkH
         l2cFPRO9vzIX3W1RyxZxgUO9y+xv3ihNwRr8I=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <BANLkTikt4y3ZKJD2Ld_hxAAzjOpevEqFfA@mail.gmail.com>
References: <1307086473.7474.1.camel@phoenix> <BANLkTikt4y3ZKJD2Ld_hxAAzjOpevEqFfA@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 3 Jun 2011 15:58:07 +0800
Message-ID: <BANLkTikEEMGwsACR0404r54jpFKZxX5S=w@mail.gmail.com>
Subject: Re: [PATCH] mtd: pxa3xx_nand: remove unused variable 'mtd'
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-mtd@lists.infradead.org,
        Lei Wen <adrian.wenl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you actually use this driver? I'm asking because there's some sort
> of nasty regression in the changes between 2.6.38 and 2.6.39 which
> makes the driver fail to work on my PXA300 based board. Lei and me
> tried to nail these issues down, but we didn't succeed yet.

hi Daniel,

I no longer have the device handy.
Last time I use this driver on a pxa310 device is running on 2.6.37 kernel.

Regards,
Axel
