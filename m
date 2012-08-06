Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2HFMg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:36:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2HFMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:36:28 -0400
Date: Mon, 6 Aug 2012 13:36:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com
Subject: Re: [PATCH 6/6] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120806123622.GA10524@gmail.com>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
 <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:46:42AM +0100, Lee Jones wrote:
> If we're booting with Device Tree enabled, we want the IRQ numbers to
> be taken and translated from the Device Tree binary. If not, they
> should be taken from the resource allocation defined in the AB8500 MFD
> core driver.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/input/misc/ab8500-ponkey.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Revoked, sent elsewhere.
