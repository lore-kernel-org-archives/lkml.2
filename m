Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2INPbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:31:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36948 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab2INPbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:31:11 -0400
Message-ID: <50534DBB.6010700@wwwdotorg.org>
Date: Fri, 14 Sep 2012 09:31:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: tegra: dt: Add pinmux entries for Vbus regulator
 controls
References: <1347614754-26357-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1347614754-26357-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 03:25 AM, Venu Byravarasu wrote:
> Adding pinmux entries for PI4 and PH7 to enable Vbus for USB1
> and USB3 controllers on Cardhu A02 board.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Given our internal discussions about whether to and how to configure
open-drain and enable-input on these pins, I'd like to hold off on this
patch. Lets resolve this internally first.

Also, I assume we'll need an equivalent patch for Cardhu A04 too.
