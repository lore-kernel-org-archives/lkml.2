Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1AQPHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:07:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64399 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1AQPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:07:10 -0500
Message-ID: <4D345AC8.8030304@ru.mvista.com>
Date: Mon, 17 Jan 2011 18:05:44 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Weber <weber@corscience.de>
CC: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 1/2] OMAP3: Devkit8000: Change lcd power pin
References: <1295273519-6189-1-git-send-email-weber@corscience.de> <1295273519-6189-2-git-send-email-weber@corscience.de>
In-Reply-To: <1295273519-6189-2-git-send-email-weber@corscience.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Weber wrote:

> The reset_gpio pin for lcd is connected with TWL4030 LedA.
> TWL4030 GPIO.1 has a not connected resistor.

> Fix indention issue.

    Indentation.

> The comment line uses 8 whitespaces. 
> Replaced with one tabulator.

> Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
> Signed-off-by: Thomas Weber <weber@corscience.de>

WBR, Sergei
