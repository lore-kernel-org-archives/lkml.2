Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1DDJYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:24:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49878 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1DDJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:24:48 -0400
Date: Mon, 4 Apr 2011 10:24:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Prchal =?utf-8?B?SmnFmcOt?= <jiri.prchal@aksignal.cz>
Cc: nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, plagnioj@jcrosoft.co,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARCH arm: adding new board: CDU
Message-ID: <20110404092434.GB19841@n2100.arm.linux.org.uk>
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B2068.60402@aksignal.cz> <4D8BA47B.8050904@bluewatersys.com> <4D998B12.1040909@aksignal.cz> <20110404091635.GA19841@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110404091635.GA19841@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 10:16:35AM +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 04, 2011 at 11:10:42AM +0200, Prchal Jiří wrote:
> > Hi,
> > this is separated PATCH adding new board CDU.
> 
> What does this have to do with
> 
> "[PATCH 1/2] mmc, ARM: Rename SuperH Mobile ARM zboot helpers" ?
> 
> which is the message which you hit your mailer's "reply" button on?
> Please don't pollute email threads.

Sorry, it's not as trivial as I thought.  For some reason your mailer is
introducing additional message IDs in the 'References' header which are
causing the message to be incorrectly threaded.  Here are the original
two messages:

From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 0/2] mmc: zboot helpers
Message-Id: <1300949648-15078-1-git-send-email-horms@verge.net.au>

From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 1/2] mmc, ARM: Rename SuperH Mobile ARM zboot helpers
Message-Id: <1300949648-15078-2-git-send-email-horms@verge.net.au>

And your messages:

From: Prchal Ji■í <jiri.prchal@aksignal.cz>
Subject: [PATCH] mmc, AT91: fix init fequency problem
References: <1300949648-15078-1-git-send-email-horms@verge.net.au>
        <1300949648-15078-2-git-send-email-horms@verge.net.au>
In-Reply-To: <1300949648-15078-2-git-send-email-horms@verge.net.au>

From: Prchal Ji■í <jiri.prchal@aksignal.cz>
Subject: [PATCH] ARCH arm: adding new board: CDU
References: <1300949648-15078-1-git-send-email-horms@verge.net.au>
        <1300949648-15078-2-git-send-email-horms@verge.net.au>
        <4D8B2068.60402@aksignal.cz> <4D8BA47B.8050904@bluewatersys.com>
In-Reply-To: <4D8BA47B.8050904@bluewatersys.com>

both of which reference Simon's unrelated emails.  No idea how you're
doing that, but both of your messages seem to be completely unrelated
to Simon's two.
