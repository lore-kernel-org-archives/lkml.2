Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab1HITds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:33:48 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36269 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HITdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:33:47 -0400
Date: Tue, 9 Aug 2011 12:34:05 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ARM: Tegra: Harmony & Seaboard USB and audio
Message-ID: <20110809193405.GA4224@quad.lixom.net>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312835715-893-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 02:35:12PM -0600, Stephen Warren wrote:
> This is a slight rev of some patches I posted a little while ago, now
> in a single series. The second patch has a minor revision that simplifies
> board-seaboard-pinmux.c.
> 
> The (previous version of the) patches were previously Ack'd by Tegra
> maintainers, and Colin asked Arnd to pick them up in arm-soc.git,
> although I'm not sure if that request still holds given the merge
> window is over?

Thanks, I've picked them up in boards-for-3.2, which will be merged in
through Arnd for 3.2.


-Olof
