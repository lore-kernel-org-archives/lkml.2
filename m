Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0LNLLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:11:07 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:40889 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab0LNLLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:11:06 -0500
Message-ID: <4D07505F.2090206@stericsson.com>
Date: Tue, 14 Dec 2010 12:09:19 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Remove ARCH_U8500 dependency from AB8500
References: <1292072869-16660-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292072869-16660-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 02:07 PM, Mark Brown wrote:
> While it is vanishingly unlikely that the device will be deployed on other
> architectures removing the dependency facilitates build testing when doing
> generic work on both the MFD core for the device and the subsystem drivers.
> 
> There appears to be no actual code dependency.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin
