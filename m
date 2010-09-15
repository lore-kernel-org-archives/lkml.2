Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0IOLUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:20:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60115 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0IOLUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iuS9POrARXa8PjUSPn68gow67XdeSJ2HCfmOZlmcj5Ki7jGHxTJO2Q/+XKWgdYbaYc
         ufwk0ljFXmksTiDGhF/ByBsDYoZ5K5hjtDm7RO5vxhL5OCGASrNLJ/hGUNQY0ZHsMcN/
         LVPnCxVUjMgXKl4hyWf7orxOjV8EE9fjon/zk=
MIME-Version: 1.0
In-Reply-To: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AC7@IL-MB01.marvell.com>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20100914190549.GA21918@void.printf.net>
	<20100915094006.GA21620@sirena.org.uk>
	<FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
	<20100915110001.GA4254@rakim.wolfsonmicro.main>
	<FCBE654890C0334289D0AD3AF4EF009FD18EE74AC7@IL-MB01.marvell.com>
Date: Wed, 15 Sep 2010 19:20:38 +0800
Message-ID: <AANLkTi=fsntfyAoFygrTrksVARvQpuxie6tFxCcuLtVR@mail.gmail.com>
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC controller
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Saeed Bishara <saeed@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 6:06 PM, Saeed Bishara <saeed@marvell.com> wrote:
>
>>Which CPUs does the driver actually support?  The Kconfig and
>>commit log
>>just say "Marvell" so I went for the conservative option and included
>>all Marvell CPUs I was aware of.
> The Marvell Dove SoC includes this device, this SoC defined by ARCH_DOVE
> I guess it found also only on mmp (defined by ARCH_MMP), Haojian, can you confirm?
> saeed

As I know, MG1 is also using this IP. Although MG1 isn't supported in
mainline, it's planned to be added into ARCH_PXA or one new ARCH. So
PLAT_PXA is preferred.

Best Regards
Haojian
