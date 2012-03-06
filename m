Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030548Ab2CFMXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:23:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480Ab2CFMXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:23:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.18.195 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <C5C3845E-9732-4A9D-B1DC-84688E7D807F@kernel.crashing.org>
References: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
	<1330424541-5299-2-git-send-email-martyn.welch@ge.com>
	<C5C3845E-9732-4A9D-B1DC-84688E7D807F@kernel.crashing.org>
Date: Tue, 6 Mar 2012 13:23:50 +0100
Message-ID: <CACRpkdaTnu+Z49CDm1Ub1H9VK9WKMd48vwWmcmhn7YHWS9_HeQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] powerpc: Move GE GPIO and PIC drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Martyn Welch <martyn.welch@ge.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linus.walleij@stericsson.com, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 1:19 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
> On Feb 28, 2012, at 4:22 AM, Martyn Welch wrote:
>
>> Move the GE GPIO and PIC drivers to allow these to be used by non-86xx
>> boards.
>
> gpio driver should be in drivers/gpio.  Please split that move out as a separate patch for Grant & Linus to review as part of the GPIO subsystem

Yes please. It will get a good home there, Grant knows everything about PPC...

Yours,
Linus Walleij
