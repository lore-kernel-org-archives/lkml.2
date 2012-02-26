Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2BZWCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:02:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35672 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2BZWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:02:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.136.97 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 26 Feb 2012 14:02:52 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Avoid compiling cpuidle code when not
 configured
Message-ID: <20120226220252.GE11189@quad.lixom.net>
References: <1330014112-26203-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330014112-26203-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 06:21:52PM +0200, Peter De Schrijver wrote:
> No need to compile cpuidle.c and sleep.S if cpuidle isn't configured in the
> kernel.

Thanks, applied to for-3.4/soc.

-Olof
