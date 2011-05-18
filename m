Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1ERFVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:21:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50013 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab1ERFV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rRN/6CsBMx1/RoozomXdMIZToc4skwXe+xKZuxXzGvbvVX4FbPyH0GlIz8kscHnfTm
         9/A7K4gKyodCQYk4/yS73BA8Ish9U4+Vpr4cC+2JdjmIHHu2VSEaGXIOVLAAK8H2xbBd
         DHZZK+0RNzz5BCcuMlnRgRSIJOg1c5QRLW2Bc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105171905150.14430@xanadu.home>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
	<201105061522.33179.arnd@arndb.de>
	<20110510055926.GA2747@redhat.com>
	<BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com>
	<20110517211223.GA1909@redhat.com>
	<alpine.LFD.2.00.1105171905150.14430@xanadu.home>
Date: Wed, 18 May 2011 07:21:29 +0200
X-Google-Sender-Auth: H01YZFCswD8f0k_U6Py5N1oKepc
Message-ID: <BANLkTimmJckFCfST73rEgqwNw=Q6L7S5mQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Nicolas Pitre <nicolas.pitre@linaro.org>:
> On Tue, 17 May 2011, Dave Jones wrote:
>> From the look of things, the Kconfig is staying under arch/arm for now ?
>
> I think this would be better if the Kconfig entry moved along with the
> code, adding the appropriate dependencies as needed.

It never had a Kconfig, it was just using the SoC Kconfig.
(It'll exit cleanly from the probe anyway.)

But I'll add something under cpufreq for it.

Linus
