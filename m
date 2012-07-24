Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2GXKFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:05:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43182 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab2GXKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:05:10 -0400
Date: Tue, 24 Jul 2012 11:04:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 07/23] ARM: LPAE: use phys_addr_t for membank size
Message-ID: <20120724100454.GD16435@mudshark.cambridge.arm.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
 <1343092165-9470-8-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343092165-9470-8-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:09:09AM +0100, Cyril Chemparathy wrote:
> This patch changes the membank structure's size field to phys_addr_t to allow
> banks larger than 4G.

This has already been fixed:

  http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7465/1

Will
