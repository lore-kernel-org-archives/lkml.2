Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2A0ITS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:19:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2A0ITQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:19:16 -0500
Date: Fri, 27 Jan 2012 00:19:12 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/8] ARM: tegra: introduce support for reading chipid
Message-ID: <20120127081912.GA13387@quad.lixom.net>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-2-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327597641-7519-2-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 26, 2012 at 07:07:06PM +0200, Peter De Schrijver wrote:
> Introduce a function to read the Tegra chipid. This will be used by the SMP
> code to distinguish between Tegra variants.
> 
> ---
> 
> Should this be merged with the fuse reading code even though this is a
> hardwired register, not a fuse based register?

Well, it's part of a register that the fuse code already reads, i.e. in
tegra_get_revision(). I'd say add it there instead of create a separate
file for it.

There's actually an opencoded version of this in that very function
already that can be cleaned up at the same time (to check for A03p vs
A03 revisions).


-Olof

