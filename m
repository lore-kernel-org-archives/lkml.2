Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab1EQXHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:07:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57139 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab1EQXHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:07:50 -0400
Date: Tue, 17 May 2011 19:07:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Dave Jones <davej@redhat.com>
cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
In-Reply-To: <20110517211223.GA1909@redhat.com>
Message-ID: <alpine.LFD.2.00.1105171905150.14430@xanadu.home>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com> <201105061522.33179.arnd@arndb.de> <20110510055926.GA2747@redhat.com> <BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com> <20110517211223.GA1909@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Dave Jones wrote:

> On Mon, May 16, 2011 at 11:02:14AM +0200, Linus Walleij wrote:
>  > Can you please look into this and ACK the patches if they
>  > seem OK?
> 
> The patch that moves the driver over looked ok to me, so feel free
> to add my acked-by to it.
> 
> From the look of things, the Kconfig is staying under arch/arm for now ?

I think this would be better if the Kconfig entry moved along with the 
code, adding the appropriate dependencies as needed.


Nicolas
