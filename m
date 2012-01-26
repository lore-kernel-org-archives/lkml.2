Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2AZTLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:11:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39295 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2AZTLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:11:37 -0500
Date: Thu, 26 Jan 2012 19:11:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Message-ID: <20120126191134.GA23484@sirena.org.uk>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
 <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
X-Cookie: Klatu barada nikto.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 06:22:03PM +0200, Peter De Schrijver wrote:
> CPUidle driver for tegra. In this version only LP3 (clockgating) is supported.

Are you aware of the work Rob Lee is doing on providing a common library
for the ARM generic bits of cpuidle?  I really must convert the s3c64xx
work I did on that over some time...
