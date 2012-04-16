Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2DPSyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:54:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45345 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2DPSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:54:30 -0400
Message-ID: <4F8C6AE3.7060907@wwwdotorg.org>
Date: Mon, 16 Apr 2012 12:54:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Colin Cross <ccross@android.com>, Danny Kukawka <dkukawka@suse.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: arch/arm/mach-tegra/board-dt-tegra20.c: included asm/hardware/gic.h
 twice
References: <1329403471-32438-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329403471-32438-1-git-send-email-danny.kukawka@bisect.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/-10/-28163 12:59 PM, Danny Kukawka wrote:
> arch/arm/mach-tegra/board-dt-tegra20.c: included 'asm/hardware/gic.h'
> twice remove the duplicates.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks. (with patch subject re-written)
