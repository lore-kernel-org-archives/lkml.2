Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0LNLMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:12:52 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51171 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757562Ab0LNLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:12:50 -0500
Message-ID: <4D07512D.5070801@stericsson.com>
Date: Tue, 14 Dec 2010 12:12:45 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Use NULL to initialise NULL pointers in ab8500-debugfs
References: <1292249320-17633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292249320-17633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 03:08 PM, Mark Brown wrote:
> Partly for coding style reasons, but mostly because sparse warns on it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin
