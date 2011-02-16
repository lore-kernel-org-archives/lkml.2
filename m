Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1BPNCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:02:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60536 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1BPNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:02:14 -0500
Date: Wed, 16 Feb 2011 10:02:06 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "Cho, Yu-Chen" <acho@novell.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlee@novell.com
Subject: Re: [PATCH] Add Atheros BT AR5BBU12 fw supported
Message-ID: <20110216130206.GB14085@joana>
References: <967f2d5b2d6382f4aa698a549d4bfa74f35c171f.1297736230.git.acho@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <967f2d5b2d6382f4aa698a549d4bfa74f35c171f.1297736230.git.acho@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cho,

* Cho, Yu-Chen <acho@novell.com> [2011-02-15 10:20:07 +0800]:

> Add the btusb.c blacklist [0489:e02c] for Atheros AR5BBU12 BT
> and add to ath3k.c supported this device.
> 
> Signed-off-by: Cho, Yu-Chen <acho@novell.com>
> ---
>  drivers/bluetooth/ath3k.c |    3 +++
>  drivers/bluetooth/btusb.c |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)

Applied to bluetooth-2.6, thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
