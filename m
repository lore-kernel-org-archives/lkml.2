Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1HaUBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:01:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1HaUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:01:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [patch v2 01/35] Hexagon: Add generic headers
Date: Wed, 31 Aug 2011 22:00:41 +0200
Message-ID: <1400760.2CJ9v55MlQ@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110831195111.GA29918@huya.qualcomm.com>
References: <20110830190729.923334292@codeaurora.org> <201108311524.42373.arnd@arndb.de> <20110831195111.GA29918@huya.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:n51jltfxEKnN39oVpH13Hc9wZxnJR5PHPIg5HbLO7z3
 uBwMbtQrIXs+fYhu1SCsIzkB6PGa+14ffV9vCd/ytDQK0CEn5p
 mhRtGPJ7Mq/j/Zpt0BJm/kwGISmZkNTaQE/XyL3Vd+E7WgZneK
 ymTM8HUIlSacTqb3wjnPFkreg7PqDoRIyqcxpfHC2EWo2Y/o0t
 7teTOH+zXysR59ozH67e2qv/TPjbcrfSMP2KCKjOQzc+mE5+BP
 g2LAJgHCgttoeopf27ld50iqh4E65R032LEYCWQfjVfCwS9zuz
 ucWWzreP41Hr9ErsAJ618qVqpHew+j8KT7tHiN+Dam62TzM0g2
 4mc6tDbZ7FZXpRmIv2eg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011 12:51:11 David Brown wrote:
> On Wed, Aug 31, 2011 at 03:24:42PM +0200, Arnd Bergmann wrote:
> > On Tuesday 30 August 2011, Richard Kuo wrote:
> > > Reworked to use the Kbuild generic headers mechanism.
> > > 
> > > Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Any suggestions on what path this code should flow to get into the
> kernel?

It should get into linux-next now and then get submitted directly to
Linus at the start of the merge window.

I'm happy to take anything that concerns hexagon and arm likewise into
the arm-soc tree.

While I am the de-facto gatekeeper for new architectures, I have not
seen a reason to start a consolidated minor-architectures tree to collect
these.

	Arnd
