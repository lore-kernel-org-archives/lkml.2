Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0LFWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:04:54 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:36717 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0LFWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:04:52 -0500
Date: Mon, 6 Dec 2010 23:04:40 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ben Hutchings <benh@debian.org>
Cc: Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/r8169: Remove the firmware of RTL8111D
Message-ID: <20101206220440.GA3853@electric-eye.fr.zoreil.com>
References: <1291180966-3124-1-git-send-email-hayeswang@realtek.com> <20101201080732.GA3234@electric-eye.fr.zoreil.com> <1291610284.8025.154.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291610284.8025.154.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <benh@debian.org> :
[...]
> I have reports that the RTL8111D/8168D hardware can work without this
> firmware, possibly with limited functionality or compatibility.  (I
> assume it is a patch for the original firmware loaded from ROM or
> flash.)  So I feel obliged to give users the choice to use the driver
> without installing non-free firmware. If you want to make the warning
> on failure of request_firmware() more explicit then that's OK with me.

I'll make it more explicit regarding what it loads, yes.

> If you make the failure fatal I will probably revert that in Debian.

I have no technical argument against yours to make the failure fatal
yet: even Realtek's wording is rather soft. I will reconsider it if
things turn ugly.

Btw, it is not too hard to build a firmware-of-freedom binary : all
zero should be fine here.

--
Ueimor
