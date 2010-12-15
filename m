Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0LOPe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:34:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LOPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:34:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/7] msm: Build support for the MSM8960 target
Date: Wed, 15 Dec 2010 16:34:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1292384961-8851-8-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1292384961-8851-8-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151634.53301.arnd@arndb.de>
X-Provags-ID: V02:K0:CUDP//7rR1YWS+PGSTp719u0VAFWpNOrOvtqPjNJ7Wg
 FCW02JAaqF0Ncou7fzzFhmVtvXvca5YE6SiHfJhNLmik8k5eTQ
 kAcjh7b4ToXX/wLZUVFJGT2lIGbtwXwTHi+A6PHjMEXi6bLaXY
 K17126NKE90U8L+YfPkLV/DfBoYjHlkIwa04q1DRJ8lZuTwpCm
 l3VqLJe/noRiwpIRapr5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, Stepan Moskovchenko wrote:
> Add the Kconfig options and Makefile options needed to
> build for the MSM8960 target. Only the simulator is
> supported at this time.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>

There is no need to split the Makefile/Kconfig changes
from the actual files implementing the functionality.
It's better to keep these together, since neither of the
patches does anything meaningful by itself.

Splitting out the cleanup as you did is good though, it
helps with review and with possible bisection or rebase
of the patches.

	Arnd
