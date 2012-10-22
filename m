Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2JVR7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:59:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2JVR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:59:11 -0400
Date: Mon, 22 Oct 2012 13:59:09 -0400 (EDT)
Message-Id: <20121022.135909.1282399641501646286.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jean@google.com
Subject: Re: [PATCH net-next 1/2] r8169: enable ALDPS for power saving
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350893153-18320-1-git-send-email-hayeswang@realtek.com>
References: <1350893153-18320-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 22 Oct 2012 16:05:53 +0800

> Enable ALDPS function to save power when link down. Note that the
> feature should be set after the other PHY settings. And the firmware
> is necessary. Don't enable it without loading the firmware.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

If there are two patches in this series, which the Subject line
implies, where is the second patch?
