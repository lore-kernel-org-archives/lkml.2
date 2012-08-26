Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2HZOc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:32:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2HZOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:32:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] video: Remove pnx4008 driver
Date: Sun, 26 Aug 2012 14:32:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        FlorianSchandinat@gmx.de
References: <1345991001-32462-1-git-send-email-stigge@antcom.de> <1345991001-32462-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1345991001-32462-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208261432.00531.arnd@arndb.de>
X-Provags-ID: V02:K0:AGdjK801uh2lvoYixPrhfFkjmFa0tj6caGGzbwVRqQL
 cR+beoXscctUjZjJHjzS2YGO0dhvuf1UIXFmK0aR4b1t/LXNt+
 EQT2gge6wK5FrimAgf7V1so5kL35NYnzjUdUN9MrolnZy7ArkG
 9n99145OgKw1278sRX7SEVxB97LrDvLxfbMxfrcRo5OfRL+M6D
 0HHNjiaLJYEuafEGpQOy8RonTnCGud5Gmdh0ZC4nDFQCae1XXj
 JItHTbPkEBdNs1FAlBWSxPSGyPwU+Ow7+vEyFgn2oeLWkxDLia
 q9T/s7PfXrjJ33CLHi8cKIPxzRlN8dOfTZhpk5ln0CijaxjNiz
 Lp6Ql4qWjvRDF3JmzAu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 August 2012, Roland Stigge wrote:
> This patch removes the video driver for pnx4008. The architecture is being
> removed via the arm-soc tree.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Florian, can you take this into your tree?

	Arnd
