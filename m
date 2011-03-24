Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab1CXTsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:48:04 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:52358 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905Ab1CXTsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:48:00 -0400
Message-ID: <4D8B9FBE.6030207@bachelot.org>
Date: Thu, 24 Mar 2011 20:47:10 +0100
From: Xavier Bachelot <xavier@bachelot.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] viafb: add VIA slapping capability
References: <1300983180-7343-1-git-send-email-FlorianSchandinat@gmx.de> <1300983180-7343-4-git-send-email-FlorianSchandinat@gmx.de>
In-Reply-To: <1300983180-7343-4-git-send-email-FlorianSchandinat@gmx.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (smeagol.schlobinux.org [192.168.1.1]); Thu, 24 Mar 2011 20:47:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 05:13 PM, Florian Tobias Schandinat wrote:
> This patch introduces dummy functions to execute when we don't know
> what we should do (due to missing documentation). They do nothing
> but print a nice message in the log explaining the situation.
> To trigger this message initial power management support is
> activated which might save a bit energy by disabling PLL and clock
> if no device is configured to use them.
> 
> Note: The message is only shown for the oldest IGPs CLE266 and K400
>       as for the other platforms there are reasonable assumptions
>       how it does (hopefully) work.
> 
> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---

> +static void dummy_set_clock_source(enum via_clksrc source, bool use_pll)
> +{
> +	printk(KERN_INFO "Using undocumented set slock soure.\n%s", via_slap);

2 typos above.

Regards,
Xavier
